import Testing

@testable import CaptchaKit

@Test func serviceUrls() async throws {
    #expect(CaptchaService.recaptcha.getURL().contains("google"))
    #expect(CaptchaService.hcaptcha.getURL().contains("hcaptcha"))
    #expect(CaptchaService.turnstile.getURL().contains("cloudflare"))
}

@Test func cloudflareTurnstile() async throws {
    let verifier = CaptchaRequest(
        service:
            CaptchaService.turnstile,
        data:
            CaptchaRequestData(
                secret: "1x0000000000000000000000000000000AA",
                token: "always"
            )
    )

    do {
        try verifier.prepare()
        try await verifier.apply()
    } catch {
        print(error)
    }
}
