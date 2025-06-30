public enum CaptchaServices {
    case recaptcha, hcaptcha, turnstile

    func getURL() -> String {
        switch self {
        case .recaptcha:
            return "https://www.google.com/recaptcha/api/siteverify"
        case .hcaptcha:
            return "https://api.hcaptcha.com/siteverify"
        case .turnstile:
            return "https://challenges.cloudflare.com/turnstile/v0/siteverify"
        }
    }
}
