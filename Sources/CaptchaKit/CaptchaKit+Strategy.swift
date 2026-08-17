import Foundation

extension CaptchaKit {
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
}
