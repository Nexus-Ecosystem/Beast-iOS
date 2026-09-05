import Foundation

final class BikeSelectionUseCase {
    private let repository: BikeSelectionRepository

    init(
        repository: BikeSelectionRepository = BikeSelectionRepositoryImpl()
    ) {
        self.repository = repository
    }

    func observeStage(
        branch: String,
        onChange: @escaping (StageSucursalModel?) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        repository.observeStage(
            branch: branch,
            onChange: onChange,
            onError: onError
        )
    }

    func observeBikeSelection(
        branch: String,
        day: String,
        month: String,
        time: String,
        onChange: @escaping ([AgendaItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        repository.observeBikeSelection(
            branch: branch,
            day: day,
            month: month,
            time: time,
            onChange: onChange,
            onError: onError
        )
    }

    func reserveBike(
        request: ApartarMobiliarioRequest
    ) async throws -> ApartarMobiliarioResponse {
        try await repository.reserveBike(
            request: request
        )
    }

    func stop() {
        repository.stopStageObserver()
        repository.stopBikeSelectionObserver()
    }
}
