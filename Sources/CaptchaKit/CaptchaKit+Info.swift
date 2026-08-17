import Foundation

extension CaptchaKit {
    /// Details reported by the provider for a successful verification.
    public struct Info: Sendable, Equatable {
        public let host: String
        public let date: Date
    }
}
