import Foundation

public enum CaptchaService {
    case recaptcha, hcaptcha, turnstile

    var url: URL {
        switch self {
        case .recaptcha:
            return URL(string: "https://www.google.com/recaptcha/api/siteverify")!
        case .hcaptcha:
            return URL(string: "https://api.hcaptcha.com/siteverify")!
        case .turnstile:
            return URL(string: "https://challenges.cloudflare.com/turnstile/v0/siteverify")!
        }
    }
}
