import Foundation
import FirebaseFirestore

final class BikeSelectionRepositoryImpl: BikeSelectionRepository {
    private let firebaseDataSource: BikeSelectionFirebaseDataSourceProtocol
    private let remoteDataSource: BikeSelectionRemoteDataSourceProtocol

    private var stageListener: ListenerRegistration?
    private var bikeSelectionListener: ListenerRegistration?

    init(
        firebaseDataSource: BikeSelectionFirebaseDataSourceProtocol = BikeSelectionFirebaseDataSource(),
        remoteDataSource: BikeSelectionRemoteDataSourceProtocol = BikeSelectionRemoteDataSource()
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.remoteDataSource = remoteDataSource
    }

    func observeStage(
        branch: String,
        onChange: @escaping (StageSucursalModel?) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        stageListener?.remove()

        stageListener = firebaseDataSource.observeStage(
            branch: branch,
            onChange: onChange,
            onError: onError
        )
    }

    func stopStageObserver() {
        stageListener?.remove()
        stageListener = nil
    }

    func observeBikeSelection(
        branch: String,
        day: String,
        month: String,
        time: String,
        onChange: @escaping ([AgendaItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        bikeSelectionListener?.remove()

        bikeSelectionListener =
            firebaseDataSource.observeBikeSelection(
                branch: branch,
                day: day,
                month: month,
                time: time,
                onChange: onChange,
                onError: onError
            )
    }

    func stopBikeSelectionObserver() {
        bikeSelectionListener?.remove()
        bikeSelectionListener = nil
    }

    func reserveBike(
        request: ApartarMobiliarioRequest
    ) async throws -> ApartarMobiliarioResponse {
        try await remoteDataSource.reserveBike(
            request: request
        )
    }

    deinit {
        stageListener?.remove()
        bikeSelectionListener?.remove()
    }
}
