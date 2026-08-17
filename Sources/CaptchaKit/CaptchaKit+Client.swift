extension CaptchaKit {
    public final class Client: Sendable {
        private let httpClient: HTTP.Client

        public init(_ config: Config) {
            httpClient = HTTP.Client(strategy: config.strategy, secret: config.secret)
        }

        public func verifyWithInfo(_ token: String, ip: String? = nil)
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

        public func verifyWithoutError(_ token: String, ip: String? = nil)
            async -> Bool
        {
            do {
                guard try await verifyWithInfo(token, ip: ip) != nil else {
                    return false
                }
            } catch {
                return false
            }

            return true
        }
    }
}
