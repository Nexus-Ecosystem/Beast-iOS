import Foundation
import Combine

@MainActor
final class PackagesViewModel: ObservableObject {
    @Published private(set) var packages: [PaqueteMemberShipModel] = []
    @Published private(set) var profile: AllDataProfileUserSystem?
    @Published private(set) var isLoading = false

    @Published var selectedPackage: PaqueteMemberShipModel?
    @Published var showPurchaseConfirmation = false
    @Published var errorMessage: String?

    private let schedulesUseCase: SchedulesUseCase
    private let storage: AppStorageManager

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.storage = storage
    }

    var userName: String {
        profile?.fullName ?? ""
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        profile = storage.getProfile()

        guard let profile else {
            isLoading = false
            errorMessage = "No se encontró la información del usuario."
            return
        }

        guard let branch = profile.branches.first else {
            isLoading = false
            errorMessage = "No se encontró una sucursal asociada."
            return
        }

        packages = await schedulesUseCase.memberships(
            branch: branch
        )

        sortPackages()

        isLoading = false
    }

    func refresh() async {
        guard
            let profile,
            let branch = profile.branches.first
        else {
            return
        }

        packages = await schedulesUseCase.memberships(
            branch: branch
        )

        sortPackages()
    }

    func selectPackage(
        _ package: PaqueteMemberShipModel
    ) {
        selectedPackage = package
        showPurchaseConfirmation = true
    }

    func dismissPurchaseConfirmation() {
        showPurchaseConfirmation = false
        selectedPackage = nil
    }

    func isActive(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        profile?.activePackage.idPaquete ==
        package.idPaquete
    }

    func isPackageEmpty(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard
            isActive(package),
            let profile
        else {
            return false
        }

        let activePackage = profile.activePackage

        guard activePackage.tipoPaquete == 2 else {
            return false
        }

        return activePackage.clasesTomadas >=
            activePackage.clasesTotales
    }

    func isExpired(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard
            isActive(package),
            let profile
        else {
            return false
        }

        let expiration =
            profile.activePackage.expiracion

        guard !expiration.isEmpty else {
            return false
        }

        guard let date = Self.dateFormatter.date(
            from: expiration
        ) else {
            return false
        }

        return Calendar.current.startOfDay(
            for: Date()
        ) > Calendar.current.startOfDay(
            for: date
        )
    }

    func canBuy(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        if !isActive(package) {
            return true
        }

        if isExpired(package) {
            return true
        }

        if isPackageEmpty(package) {
            return true
        }

        return false
    }

    func actionTitle(
        for package: PaqueteMemberShipModel
    ) -> String {
        if !isActive(package) {
            return "ADQUIRIR"
        }

        if isExpired(package) {
            return "RENOVAR"
        }

        if isPackageEmpty(package) {
            return "RENOVAR"
        }

        return "YA TIENES ESTE PLAN"
    }

    func resetError() {
        errorMessage = nil
    }

    private func sortPackages() {
        guard let profile else {
            return
        }

        let activeId =
            profile.activePackage.idPaquete

        guard !activeId.isEmpty else {
            return
        }

        packages.sort {
            if $0.idPaquete == activeId {
                return true
            }

            if $1.idPaquete == activeId {
                return false
            }

            return false
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
