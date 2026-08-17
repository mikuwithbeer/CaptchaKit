import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class HTTPClient: Sendable {
    let strategy: CaptchaKit.Strategy

    private let session: URLSession
    private let secret: String

    init(strategy: CaptchaKit.Strategy, secret: String) {
        self.strategy = strategy

        self.session = URLSession(configuration: .ephemeral)
        self.secret = secret
    }

    func send(_ request: HTTPRequest)
        async throws(CaptchaKit.Error) -> HTTPResponse
    {
        let urlRequest = try makeRequest(request)
        return try await performRequest(urlRequest)
    }

    private func makeRequest(_ request: HTTPRequest)
        throws(CaptchaKit.Error) -> URLRequest
    {
        var urlRequest = URLRequest(url: strategy.verificationURL)

        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try request.encode(with: secret)

        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }

    private func performRequest(_ urlRequest: URLRequest)
        async throws(CaptchaKit.Error) -> HTTPResponse
    {
        let data: Data

        do {
            (data, _) = try await session.data(for: urlRequest)
        } catch {
            throw .networkFailure(error)
        }

        let response = try HTTPResponse.decode(from: data)

        if let errorValues = response.errors {
            if !errorValues.isEmpty {
                throw .captchaFailure(errorValues)
            }
        }

        return response
    }
}
