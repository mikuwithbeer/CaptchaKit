import Foundation

public enum CaptchaKit {
    public enum Error: Swift.Error {
        case requestEncodingFailed
        case responseDecodingFailed(DecodingError)
        case networkFailure(any Swift.Error)
        case captchaFailure([String])
        case unexpected(any Swift.Error)
    }

    public enum Strategy: Sendable, Equatable {
        case recaptcha
        case hcaptcha
        case turnstile

        var verificationURL: URL {
            switch self {
            case .recaptcha:
                URL(string: "https://www.google.com/recaptcha/api/siteverify")!
            case .hcaptcha:
                URL(string: "https://api.hcaptcha.com/siteverify")!
            case .turnstile:
                URL(string: "https://challenges.cloudflare.com/turnstile/v0/siteverify")!
            }
        }
    }

    public struct Config: Equatable {
        public let strategy: Strategy
        public let secret: String

        public init(strategy: Strategy, secret: String) {
            self.strategy = strategy
            self.secret = secret
        }
    }

    public struct Metadata: Equatable {
        public let host: String
        public let date: Date
    }

    public final class Client: Sendable {
        private let httpClient: HTTPClient

        public init(_ config: Config) {
            httpClient = HTTPClient(strategy: config.strategy, secret: config.secret)
        }

        public func verifyWithMetadata(_ token: String, ip: String? = nil)
            async throws(Error) -> Metadata?
        {
            let request = HTTPRequest(token: token, ip: ip)
            let response = try await httpClient.send(request)

            if response.verified {
                return Metadata(host: response.host!, date: response.timestamp!)
            } else {
                return nil
            }
        }

        public func verifyAsBool(_ token: String, ip: String? = nil)
            async -> Bool
        {
            do {
                let metadata = try await verifyWithMetadata(token, ip: ip)

                if metadata != nil {
                    return true
                } else {
                    return false
                }
            } catch {
                return false
            }
        }
    }
}
