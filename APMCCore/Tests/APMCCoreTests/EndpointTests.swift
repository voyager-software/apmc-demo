import Testing
@testable import APMCCore

struct EndpointTests {
    @Test func getVideosEndpoint() async throws {
        #expect(MockyEndpoint.getVideos.url == "https://run.mocky.io/v3/8419df8e-0160-4a35-a1e6-0237a527c566")
    }
}
