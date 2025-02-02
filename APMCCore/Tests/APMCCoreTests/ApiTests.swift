import Testing
@testable import APMCCore

struct ApiTests {
    @Test func getVideosSuccess() async throws {
        let svc = VideoService()

        let videos = try await svc.getVideos()

        #expect(videos.count > 0)
    }

    @Test func getVideosUsingInvalidUrl() async throws {
        let svc = FaultyService()

        await #expect(throws: HttpError.self) {
            let _ = try await svc.getVideos()
        }
    }
}

final class FaultyService: MockyService, @unchecked Sendable {
    // MARK: Lifecycle

    override public init() {}

    // MARK: Internal

    func getVideos() async throws -> [Video] {
        let endpoint = MockyEndpoint(.get, "someinvalidurl")
        return try await self.req(endpoint, of: [Video].self)
    }
}
