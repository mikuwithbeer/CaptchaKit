import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class CaptchaClient {
    let service: CaptchaService

    private let session: URLSession
    private let secret: String

    init(service: CaptchaService, secret: String) {
        self.service = service

        self.session = URLSession(configuration: .ephemeral)
        self.secret = secret
    }

    public func send(request: CaptchaRequest) async throws(CaptchaError) -> CaptchaResponse {
        let urlRequest = try buildRequest(request: request)
        return try await applyRequest(request: urlRequest)
    }

    private func buildRequest(request: CaptchaRequest) throws(CaptchaError) -> URLRequest {
        var urlRequest = URLRequest(url: service.url)

        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try request.encode(secret: secret)

        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }

    private func applyRequest(request: URLRequest) async throws(CaptchaError) -> CaptchaResponse {
        do {
            let (data, _) = try await session.data(for: request)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return try decoder.decode(CaptchaResponse.self, from: data)
        } catch let error as DecodingError {
            throw .responseDecodingFailed(error)
        } catch {
            throw .networkRequestFailed(error)
        }
    }
}
