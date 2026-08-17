extension CaptchaKit {
    public struct Config: Sendable, Equatable {
        public let strategy: Strategy
        public let secret: String

        public init(strategy: Strategy, secret: String) {
            self.strategy = strategy
            self.secret = secret
        }
    }
}
