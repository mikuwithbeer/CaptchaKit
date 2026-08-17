import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public final class CaptchaClient {
    public let service: CaptchaService

    private let session: URLSession
    private let secret: String

    public init(service: CaptchaService, secret: String) {
        self.service = service

        self.session = URLSession(configuration: .ephemeral)
        self.secret = secret
    }

    public func send(_ request: CaptchaRequest)
        async throws(CaptchaError) -> CaptchaResponse
    {
        let urlRequest = try buildRequest(request)
        return try await performRequest(urlRequest)
    }

    private func buildRequest(_ request: CaptchaRequest)
        throws(CaptchaError) -> URLRequest
    {
        var urlRequest = URLRequest(url: service.verificationURL)

        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try request.encode(with: secret)

        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }

    private func performRequest(_ urlRequest: URLRequest)
        async throws(CaptchaError) -> CaptchaResponse
    {
        let data: Data

        do {
            let (responseData, _) = try await session.data(for: urlRequest)
            data = responseData
        } catch {
            throw .networkFailure(error)
        }

        return try CaptchaResponse.load(from: data)
    }
}
