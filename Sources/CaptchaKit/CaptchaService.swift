import Foundation

/// Supported CAPTCHA verification services.
public enum CaptchaService {
    /// Google reCAPTCHA verification service.
    case recaptcha
    /// hCaptcha verification service.
    case hcaptcha
    /// Cloudflare Turnstile verification service.
    case turnstile

    /// The verification endpoint URL for the selected service.
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
