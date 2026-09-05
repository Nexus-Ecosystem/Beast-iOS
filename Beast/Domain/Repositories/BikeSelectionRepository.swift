import Foundation

protocol BikeSelectionRepository {
    func observeStage(
        branch: String,
        onChange: @escaping (StageSucursalModel?) -> Void,
        onError: @escaping (Error) -> Void
    )

    func stopStageObserver()

    func observeBikeSelection(
        branch: String,
        day: String,
        month: String,
        time: String,
        onChange: @escaping ([AgendaItem]) -> Void,
        onError: @escaping (Error) -> Void
    )

    func stopBikeSelectionObserver()

    func reserveBike(
        request: ApartarMobiliarioRequest
    ) async throws -> ApartarMobiliarioResponse
}
