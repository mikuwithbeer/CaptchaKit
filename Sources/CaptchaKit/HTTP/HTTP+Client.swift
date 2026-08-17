import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension HTTP {
    /// The internal HTTP client responsible for communicating with providers.
    final class Client: Sendable {
        let strategy: CaptchaKit.Strategy

        private let session: URLSession
        private let secret: String

        init(strategy: CaptchaKit.Strategy, secret: String) {
            self.strategy = strategy

            // Prevents cached or cookie state from affecting verification.
            self.session = URLSession(configuration: .ephemeral)
            self.secret = secret
        }

        func send(_ request: Request)
            async throws(CaptchaKit.Error) -> Response
        {
            let urlRequest = try makeRequest(request)
            return try await performRequest(urlRequest)
        }

        private func makeRequest(_ request: Request)
            throws(CaptchaKit.Error) -> URLRequest
        {
            var urlRequest = URLRequest(url: strategy.verificationURL)

            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = try request.encode(with: secret)

            urlRequest.setValue(
                "application/json",
                forHTTPHeaderField: "Accept"
            )

            urlRequest.setValue(
                "application/x-www-form-urlencoded",
                forHTTPHeaderField: "Content-Type"
            )

            return urlRequest
        }

        private func performRequest(_ urlRequest: URLRequest)
            async throws(CaptchaKit.Error) -> Response
        {
            let data: Data

            do {
                (data, _) = try await session.data(for: urlRequest)
            } catch {
                throw .networkFailure(error)
            }

            let response = try Response.decode(from: data)

            // Providers also report validation failures inside a valid response.
            if let errorValues = response.errors, !errorValues.isEmpty {
                throw .strategyFailure(errorValues)
            }

            return response
        }
    }
}
