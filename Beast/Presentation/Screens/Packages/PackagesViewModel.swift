import Foundation
import Combine

@MainActor
final class PackagesViewModel: ObservableObject {

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed
    }

    @Published private(set)
    var packages: [PaqueteMemberShipModel] = []

    @Published private(set)
    var profile: AllDataProfileUserSystem?

    @Published private(set)
    var loadState: LoadState = .idle

    @Published
    var selectedPackage: PaqueteMemberShipModel?

    @Published
    var showPurchaseConfirmation = false

    @Published
    var errorMessage: String?

    private let schedulesUseCase: SchedulesUseCase
    private let storage: AppStorageManager

    private var hasLoadedOnce = false

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.storage = storage
    }

    // MARK: - State

    var isLoading: Bool {
        loadState == .loading
    }

    var hasFinishedInitialLoad: Bool {
        loadState == .loaded ||
        loadState == .failed
    }

    var shouldShowEmptyState: Bool {
        hasFinishedInitialLoad &&
        errorMessage == nil &&
        packages.isEmpty
    }

    // MARK: - Profile

    var userName: String {
        profile?.fullName ?? ""
    }

    var activePackageId: String {
        profile?.activePackage.idPaquete ?? ""
    }

    // MARK: - Membership

    var hasActivePackage: Bool {
        guard !activePackageId.isEmpty else {
            return false
        }

        return packages.contains {
            $0.idPaquete == activePackageId
        }
    }

    var featuredPackage: PaqueteMemberShipModel? {
        if
            !activePackageId.isEmpty,
            let activePackage = packages.first(
                where: {
                    $0.idPaquete == activePackageId
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
            $0.idPaquete != featuredPackage.idPaquete
        }
    }

    // MARK: - Load

    func load() async {
        guard !hasLoadedOnce else {
            return
        }

        await loadPackages(
            showLoader: true
        )
    }

    func refresh() async {
        await loadPackages(
            showLoader: packages.isEmpty
        )
    }

    private func loadPackages(
        showLoader: Bool
    ) async {
        if showLoader {
            loadState = .loading
        }

        errorMessage = nil

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📦 PACKAGES: INICIANDO CARGA")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        guard let storedProfile = storage.getProfile() else {
            print("❌ PACKAGES: storage.getProfile() == nil")

            profile = nil
            packages = []
            loadState = .failed
            hasLoadedOnce = true

            errorMessage =
                "No se encontró la información del usuario."

            return
        }

        profile = storedProfile

        print("✅ PACKAGES: perfil encontrado")
        print("👤 Usuario:", storedProfile.fullName)
        print("📧 Email:", storedProfile.email)
        print(
            "⭐ Paquete activo:",
            storedProfile.activePackage.idPaquete
        )
        print(
            "🏢 Sucursales encontradas:",
            storedProfile.branches.count
        )

        guard let branch = storedProfile.branches.first else {
            print("❌ PACKAGES: perfil sin sucursales")

            packages = []
            loadState = .failed
            hasLoadedOnce = true

            errorMessage =
                "No se encontró una sucursal asociada."

            return
        }

        print("📍 PACKAGES: branch encontrado")
        print("📍 Branch:", branch)

        print("🔥 PACKAGES: consultando membresías...")

        let loadedPackages =
            await schedulesUseCase.memberships(
                branch: branch
            )

        print(
            "📦 PACKAGES: paquetes recibidos:",
            loadedPackages.count
        )

        for package in loadedPackages {
            print(
                "   📦",
                package.idPaquete
            )
        }

        packages = loadedPackages

        loadState = .loaded
        hasLoadedOnce = true

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("✅ PACKAGES: CARGA TERMINADA")
        print("📦 Total:", packages.count)
        print("⭐ Activo:", activePackageId)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }

    // MARK: - Selection

    func selectPackage(
        _ package: PaqueteMemberShipModel
    ) {
        guard canBuy(package) else {
            return
        }

        selectedPackage = package
        showPurchaseConfirmation = true
    }

    func dismissPurchaseConfirmation() {
        showPurchaseConfirmation = false
        selectedPackage = nil
    }

    // MARK: - Active Package

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

        guard
            let expirationDate =
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

        return today > expirationDay
    }

    // MARK: - Purchase

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

        if isExpired(package) ||
            isPackageEmpty(package) {
            return "RENOVAR"
        }

        return "YA TIENES ESTE PLAN"
    }

    // MARK: - Error

    func resetError() {
        errorMessage = nil
    }

    // MARK: - Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()
}
