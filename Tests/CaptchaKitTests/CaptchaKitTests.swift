import Testing

@testable import CaptchaKit

@Test func serviceUrls() async throws {
    #expect(CaptchaService.recaptcha.getURL().contains("google"))
    #expect(CaptchaService.hcaptcha.getURL().contains("hcaptcha"))
    #expect(CaptchaService.turnstile.getURL().contains("cloudflare"))
}

@Test func cloudflareTurnstile() async throws {
    print(
        try await verify(
            "always", service: CaptchaService.turnstile,
            secret: "1x0000000000000000000000000000000AA")
    )

}
