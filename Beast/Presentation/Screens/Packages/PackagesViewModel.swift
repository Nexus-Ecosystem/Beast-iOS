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
        self.schedulesUseCase =
            schedulesUseCase
        self.storage =
            storage
    }

    var userName: String {
        profile?.fullName ?? ""
    }

    var activePackageId: String {
        profile?.activePackage.idPaquete ?? ""
    }

    var hasActivePackage: Bool {
        guard !activePackageId.isEmpty else {
            return false
        }

        return packages.contains {
            $0.idPaquete == activePackageId
        }
    }

    var featuredPackage: PaqueteMemberShipModel? {
        if !activePackageId.isEmpty,
           let activePackage =
            packages.first(
                where: {
                    $0.idPaquete ==
                    activePackageId
                }
            )
        {
            return activePackage
        }

        return packages.first
    }

    var otherPackages: [PaqueteMemberShipModel] {
        guard let featuredPackage else {
            return []
        }

        return packages.filter {
            $0.idPaquete !=
            featuredPackage.idPaquete
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        profile =
            storage.getProfile()

        guard let profile else {
            isLoading = false
            errorMessage =
                "No se encontró la información del usuario."
            return
        }

        guard let branch =
            profile.branches.first
        else {
            isLoading = false
            errorMessage =
                "No se encontró una sucursal asociada."
            return
        }

        packages =
            await schedulesUseCase
                .memberships(
                    branch: branch
                )

        isLoading = false
    }

    func refresh() async {
        profile =
            storage.getProfile()

        guard
            let profile,
            let branch =
                profile.branches.first
        else {
            return
        }

        packages =
            await schedulesUseCase
                .memberships(
                    branch: branch
                )
    }

    func selectPackage(
        _ package: PaqueteMemberShipModel
    ) {
        guard canBuy(package) else {
            return
        }

        selectedPackage =
            package

        showPurchaseConfirmation =
            true
    }

    func dismissPurchaseConfirmation() {
        showPurchaseConfirmation =
            false

        selectedPackage =
            nil
    }

    func isActive(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard !activePackageId.isEmpty else {
            return false
        }

        return activePackageId ==
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

        let activePackage =
            profile.activePackage

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

        guard let expirationDate =
            Self.dateFormatter.date(
                from: expiration
            )
        else {
            return false
        }

        let today =
            Calendar.current.startOfDay(
                for: Date()
            )

        let expirationDay =
            Calendar.current.startOfDay(
                for: expirationDate
            )

        return today >
            expirationDay
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
        guard isActive(package) else {
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
        errorMessage =
            nil
    }

    private static let dateFormatter: DateFormatter = {
        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier:
                    "en_US_POSIX"
            )

        formatter.dateFormat =
            "yyyy-MM-dd"

        return formatter
    }()
}
