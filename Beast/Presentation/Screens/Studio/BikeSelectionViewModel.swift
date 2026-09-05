import Foundation
import Combine

@MainActor
final class BikeSelectionViewModel: ObservableObject {
    @Published private(set) var stage: StageSucursalModel?
    @Published private(set) var realtimeSelections: [AgendaItem] = []
    @Published private(set) var profile: AllDataProfileUserSystem?
    @Published private(set) var isLoading = false

    @Published var selectedBike: StudioElementModel?
    @Published var showSuccess = false
    @Published var showError = false
    @Published var message = ""

    private let useCase: BikeSelectionUseCase
    private let storage: AppStorageManager

    private var branch = ""

    init(
        useCase: BikeSelectionUseCase = BikeSelectionUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.useCase = useCase
        self.storage = storage
    }

    func load(
        context: BikeSelectionContext
    ) {
        guard let profile = storage.getProfile() else {
            message = "No se encontró el perfil del usuario."
            showError = true
            return
        }

        self.profile = profile
        branch = profile.branches.first ?? ""

        guard !branch.isEmpty else {
            message = "No se encontró la sucursal del usuario."
            showError = true
            return
        }

        isLoading = true

        useCase.observeStage(
            branch: branch,
            onChange: { [weak self] stage in
                guard let self else { return }

                self.stage = stage
                self.isLoading = false
            },
            onError: { [weak self] error in
                guard let self else { return }

                self.isLoading = false
                self.message = error.localizedDescription
                self.showError = true
            }
        )

        useCase.observeBikeSelection(
            branch: branch,
            day: context.day,
            month: context.month,
            time: context.classItem.time,
            onChange: { [weak self] selections in
                self?.realtimeSelections = selections
            },
            onError: { [weak self] error in
                self?.message = error.localizedDescription
                self?.showError = true
            }
        )
    }

    func select(
        _ element: StudioElementModel
    ) {
        guard isSelectable(element) else {
            return
        }

        selectedBike = element
    }

    func closeBikeConfirmation() {
        selectedBike = nil
    }

    func confirmBike(
        context: BikeSelectionContext
    ) {
        guard
            let bike = selectedBike,
            let profile
        else {
            return
        }

        selectedBike = nil
        isLoading = true

        Task {
            do {
                let response = try await useCase.reserveBike(
                    request: ApartarMobiliarioRequest(
                        numMobiliario: bike.label,
                        idSucursal: branch,
                        email: profile.email,
                        mes: context.month,
                        dia: context.day,
                        hora: context.classItem.time
                    )
                )

                isLoading = false

                if response.success {
                    message =
                        response.message ??
                        "Tu bicicleta fue seleccionada correctamente."

                    showSuccess = true
                } else {
                    message =
                        response.message ??
                        "No fue posible seleccionar la bicicleta."

                    showError = true
                }
            } catch {
                isLoading = false
                message = error.localizedDescription
                showError = true
            }
        }
    }

    func closeSuccess() {
        showSuccess = false
    }

    func closeError() {
        showError = false
    }

    func assignment(
        for element: StudioElementModel
    ) -> AgendaItem? {
        realtimeSelections.first {
            $0.asignacionMobiliario == element.label ||
            $0.asignacionMobiliario == String(element.id)
        }
    }

    func isMyBike(
        _ element: StudioElementModel
    ) -> Bool {
        guard
            let assignment = assignment(
                for: element
            ),
            let email = profile?.email
        else {
            return false
        }

        return assignment.correo.caseInsensitiveCompare(
            email
        ) == .orderedSame
    }

    func isOccupied(
        _ element: StudioElementModel
    ) -> Bool {
        guard
            element.type == "bike",
            assignment(for: element) != nil
        else {
            return false
        }

        return !isMyBike(
            element
        )
    }

    func isSelectable(
        _ element: StudioElementModel
    ) -> Bool {
        element.type == "bike" &&
        element.status == "active" &&
        !isOccupied(element)
    }

    deinit {
        useCase.stop()
    }
}
