extension CaptchaKit {
    /// A high-level client for validating tokens with the configured provider.
    public final class Client: Sendable {
        private let httpClient: HTTP.Client

        public init(_ config: Config) {
            httpClient = HTTP.Client(strategy: config.strategy, secret: config.secret)
        }

        /// Verifies a token and returns information about the challenge.
        ///
        /// - Throws: An ``Error`` when verification fails, including invalid tokens, request failures, and malformed provider responses.
        public func verifyDetails(_ token: String, ip: String? = nil)
            async throws(Error) -> Info?
        {
            let request = HTTP.Request(token: token, ip: ip)
            let response = try await httpClient.send(request)

            if response.verified {
                guard let host = response.host, let date = response.timestamp else {
                    throw .responseFailure
                }

                return Info(host: host, date: date)
            } else {
                return nil
            }
        }

        /// Verifies a token without propagating verification errors.
        ///
        /// This is a convenient option when you only care whether a token is valid.
        /// Any error encountered during verification is treated as a failed verification.
        ///
        /// - Returns: `true` if the token was successfully verified, `false` otherwise.
        public func isValid(_ token: String, ip: String? = nil)
            async -> Bool
        {
            do {
                guard try await verifyDetails(token, ip: ip) != nil else {
                    return false
                }
            } catch {
                return false
            }

            return true
        }
    }
}
