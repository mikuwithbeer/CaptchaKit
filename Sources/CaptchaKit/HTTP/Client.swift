import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public final class CaptchaHTTPClient {
    public let service: CaptchaHTTPService

    private let session: URLSession
    private let secret: String

    public init(service: CaptchaHTTPService, secret: String) {
        self.service = service

        self.session = URLSession(configuration: .ephemeral)
        self.secret = secret
    }

    public func send(_ request: CaptchaHTTPRequest)
        async throws(CaptchaError) -> CaptchaHTTPResponse
    {
        let urlRequest = try buildRequest(request)
        return try await performRequest(urlRequest)
    }

    private func buildRequest(_ request: CaptchaHTTPRequest)
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
        async throws(CaptchaError) -> CaptchaHTTPResponse
    {
        let data: Data

        do {
            let (responseData, _) = try await session.data(for: urlRequest)
            data = responseData
        } catch {
            throw .networkFailure(error)
        }

        return try CaptchaHTTPResponse.load(from: data)
    }
}
