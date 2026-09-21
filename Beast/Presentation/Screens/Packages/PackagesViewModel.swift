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

    @Published private(set) var packages: [PaqueteMemberShipModel] = []
    @Published private(set) var profile: AllDataProfileUserSystem?
    @Published private(set) var realtimeProfile: ProfileDisplayModel = .empty
    @Published private(set) var branchPhone = ""
    @Published private(set) var loadState: LoadState = .idle
    @Published var errorMessage: String?

    private let schedulesUseCase: SchedulesUseCase
    private let branchesUseCase: BranchesUseCase
    private let profileUseCase: ProfileUseCase
    private let storage: AppStorageManager

    private var didStart = false

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        branchesUseCase: BranchesUseCase = BranchesUseCase(),
        profileUseCase: ProfileUseCase = ProfileUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.branchesUseCase = branchesUseCase
        self.profileUseCase = profileUseCase
        self.storage = storage
    }

    // MARK: - State

    var isLoading: Bool {
        loadState == .loading
    }

    var hasFinishedInitialLoad: Bool {
        loadState == .loaded || loadState == .failed
    }

    var shouldShowEmptyState: Bool {
        hasFinishedInitialLoad &&
        errorMessage == nil &&
        packages.isEmpty
    }

    var userName: String {
        profile?.fullName ?? ""
    }

    var userPhone: String {
        profile?.phone ?? ""
    }

    var branchId: String {
        profile?.branches.first ?? ""
    }

    // MARK: - Active Package

    var activePackageId: String {
        if !realtimeProfile.packageId.isEmpty {
            return realtimeProfile.packageId
        }

        return profile?.activePackage.idPaquete ?? ""
    }

    var activePackageType: Int {
        if !realtimeProfile.packageId.isEmpty {
            return realtimeProfile.packageType
        }

        return profile?.activePackage.tipoPaquete ?? 0
    }

    var classesTaken: Int {
        if !realtimeProfile.packageId.isEmpty {
            return realtimeProfile.classesTaken
        }

        return profile?.activePackage.clasesTomadas ?? 0
    }

    var totalClasses: Int {
        if !realtimeProfile.packageId.isEmpty {
            return realtimeProfile.totalClasses
        }

        return profile?.activePackage.clasesTotales ?? 0
    }

    var activePackageExpiration: String {
        if !realtimeProfile.packageId.isEmpty {
            return realtimeProfile.packageExpiration
        }

        return profile?.activePackage.expiracion ?? ""
    }

    // MARK: - Packages

    var featuredPackage: PaqueteMemberShipModel? {
        if !activePackageId.isEmpty,
           let active = packages.first(where: {
               $0.idPaquete == activePackageId
           }) {
            return active
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

    // MARK: - Lifecycle

    func load() async {
        guard !didStart else {
            return
        }

        didStart = true
        loadState = .loading
        errorMessage = nil

        guard let localProfile = storage.getProfile() else {
            handleLoadError(
                "No se encontró la información del usuario."
            )
            return
        }

        guard !localProfile.email.isEmpty else {
            handleLoadError(
                "No se encontró el correo del usuario."
            )
            return
        }

        profile = localProfile
        realtimeProfile = makeDisplayProfile(from: localProfile)

        guard let branchId = localProfile.branches.first,
              !branchId.isEmpty else {
            handleLoadError(
                "No se encontró una sucursal asociada."
            )
            return
        }

        await loadBranchData(
            branchId: branchId,
            showLoader: true
        )

        observeProfile(
            email: localProfile.email
        )
    }

    func refresh() async {
        guard let localProfile = storage.getProfile() else {
            handleLoadError(
                "No se encontró la información del usuario."
            )
            return
        }

        profile = localProfile

        guard let branchId = localProfile.branches.first,
              !branchId.isEmpty else {
            handleLoadError(
                "No se encontró una sucursal asociada."
            )
            return
        }

        await loadBranchData(
            branchId: branchId,
            showLoader: packages.isEmpty
        )
    }

    func stop() {
        didStart = false
        profileUseCase.stopProfileObserver()
    }

    // MARK: - Realtime Profile

    private func observeProfile(
        email: String
    ) {
        profileUseCase.stopProfileObserver()

        profileUseCase.observeProfile(
            email: email,
            onChange: { [weak self] updatedProfile in
                guard let self else {
                    return
                }

                self.handleProfileUpdate(
                    updatedProfile
                )
            },
            onError: { [weak self] error in
                guard let self else {
                    return
                }

                self.errorMessage =
                    error.localizedDescription

                if self.loadState == .loading {
                    self.loadState = .failed
                }
            }
        )
    }

    private func handleProfileUpdate(
        _ updatedProfile: ProfileDisplayModel
    ) {
        let previousPackageId =
            activePackageId

        realtimeProfile =
            updatedProfile

        let currentPackageId =
            updatedProfile.packageId

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🔥 PACKAGES REALTIME")
        print("📦 Previous: \(previousPackageId)")
        print("📦 Current: \(currentPackageId)")
        print("📊 Type: \(updatedProfile.packageType)")
        print(
            "🏋️ Classes: \(updatedProfile.classesTaken)/\(updatedProfile.totalClasses)"
        )
        print(
            "📅 Expiration: \(updatedProfile.packageExpiration)"
        )
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        errorMessage = nil

        if loadState != .loaded {
            loadState = .loaded
        }
    }

    // MARK: - Branch

    private func loadBranchData(
        branchId: String,
        showLoader: Bool
    ) async {
        if showLoader {
            loadState = .loading
        }

        errorMessage = nil

        async let packagesTask =
            schedulesUseCase.memberships(
                branch: branchId
            )

        async let phoneTask =
            resolveBranchPhone(
                branchId: branchId
            )

        let loadedPackages =
            await packagesTask

        let loadedPhone =
            await phoneTask

        packages = loadedPackages
        branchPhone = loadedPhone
        loadState = .loaded

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📦 PACKAGES LOADED")
        print("🏢 Branch: \(branchId)")
        print("📦 Total: \(packages.count)")
        print("⭐ Active: \(activePackageId)")
        print("📱 Phone: \(branchPhone)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }

    private func resolveBranchPhone(
        branchId: String
    ) async -> String {
        do {
            let branches =
                try await branchesUseCase
                    .getAllBranches()

            let branch =
                branches.first {
                    $0.idBranch == branchId
                }

            let phone =
                branch?.phone
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ) ?? ""

            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("🏢 BRANCH PURCHASE DEBUG")
            print("🆔 Branch ID: \(branchId)")
            print(
                "🏢 Branch: \(branch?.name ?? "NO ENCONTRADA")"
            )
            print("📱 Phone: \(phone)")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

            return phone
        } catch {
            print(
                "❌ Error obteniendo sucursal: \(error.localizedDescription)"
            )

            return ""
        }
    }

    // MARK: - Package Logic

    func isActive(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard !activePackageId.isEmpty else {
            return false
        }

        return package.idPaquete ==
            activePackageId
    }

    func isPackageEmpty(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard isActive(package) else {
            return false
        }

        guard activePackageType == 2 else {
            return false
        }

        guard totalClasses > 0 else {
            return false
        }

        return classesTaken >= totalClasses
    }

    func isExpired(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard isActive(package) else {
            return false
        }

        guard !activePackageExpiration.isEmpty,
              let expirationDate =
                Self.parseDate(
                    activePackageExpiration
                ) else {
            return false
        }

        let calendar =
            Calendar.current

        let today =
            calendar.startOfDay(
                for: Date()
            )

        let expirationDay =
            calendar.startOfDay(
                for: expirationDate
            )

        return today > expirationDay
    }

    func canBuy(
        _ package: PaqueteMemberShipModel
    ) -> Bool {
        guard isActive(package) else {
            return true
        }

        return isPackageEmpty(package) ||
            isExpired(package)
    }

    func actionTitle(
        for package: PaqueteMemberShipModel
    ) -> String {
        guard isActive(package) else {
            return "ADQUIRIR"
        }

        if isPackageEmpty(package) {
            return "RENOVAR"
        }

        if isExpired(package) {
            return "PAQUETE EXPIRADO"
        }

        return "YA TIENES ESTE PLAN"
    }

    // MARK: - Mapping

    private func makeDisplayProfile(
        from profile: AllDataProfileUserSystem
    ) -> ProfileDisplayModel {
        let active =
            profile.activePackage

        return ProfileDisplayModel(
            fullName: profile.fullName,
            email: profile.email,
            phone: profile.phone,
            photoURL:
                profile.fotoPerfil.isEmpty
                ? profile.urlPhoto
                : profile.fotoPerfil,
            packageId:
                active.idPaquete,
            packageName:
                active.name,
            packageExpiration:
                active.expiracion,
            packageType:
                active.tipoPaquete,
            classesTaken:
                active.clasesTomadas,
            totalClasses:
                active.clasesTotales,
            extraCredits: 0,
            responsiveSigned:
                profile.responsiveSigned,
            responsiveURL:
                profile.urlDocumentResponsiva
        )
    }

    // MARK: - Error

    func resetError() {
        errorMessage = nil
    }

    private func handleLoadError(
        _ message: String
    ) {
        packages = []
        branchPhone = ""
        loadState = .failed
        errorMessage = message
    }

    // MARK: - Date

    private static func parseDate(
        _ value: String
    ) -> Date? {
        dateFormatter.date(
            from: String(
                value.prefix(10)
            )
        )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.locale =
            Locale(
                identifier: "en_US_POSIX"
            )

        formatter.calendar =
            Calendar(
                identifier: .gregorian
            )

        formatter.dateFormat =
            "yyyy-MM-dd"

        return formatter
    }()
}
