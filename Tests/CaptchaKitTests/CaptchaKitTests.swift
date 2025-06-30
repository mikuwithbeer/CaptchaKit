import Testing

@testable import CaptchaKit

@Test func serviceUrls() async throws {
    #expect(CaptchaServices.recaptcha.getURL().contains("google"))
    #expect(CaptchaServices.hcaptcha.getURL().contains("hcaptcha"))
    #expect(CaptchaServices.turnstile.getURL().contains("cloudflare"))
}
