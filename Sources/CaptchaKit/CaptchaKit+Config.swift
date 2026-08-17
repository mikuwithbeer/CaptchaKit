extension CaptchaKit {
    /// Configuration used to connect to a provider.
    public struct Config: Sendable, Equatable {
        /// The provider to use for verification.
        public let strategy: Strategy

        /// The secret key used to authenticate verification requests.
        public let secret: String

        public init(strategy: Strategy, secret: String) {
            self.strategy = strategy
            self.secret = secret
        }
    }
}
