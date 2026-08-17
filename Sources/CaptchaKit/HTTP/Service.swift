import Foundation

public enum CaptchaHTTPService {
    case recaptcha
    case hcaptcha
    case turnstile

    public var verificationURL: URL {
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
