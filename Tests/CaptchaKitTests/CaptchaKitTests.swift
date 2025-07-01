import Testing

@testable import CaptchaKit

@Test func cloudflareTurnstile() async throws(CaptchaError) {
    let result = try await verifyCaptcha(
        "pass",
        service: CaptchaService.turnstile,
        secret: "1x0000000000000000000000000000000AA"
    )

    #expect(result, "Turnstile should return success for test token")
}

@Test func hCaptcha() async throws(CaptchaError) {
    let result = try await verifyCaptcha(
        "10000000-aaaa-bbbb-cccc-000000000001",
        service: CaptchaService.hcaptcha,
        secret: "0x0000000000000000000000000000000000000000"
    )

    #expect(result, "hCaptcha should return success for test token")
}

@Test func reCaptcha() async throws(CaptchaError) {
    let result = try await verifyCaptcha(
        "pass",
        service: CaptchaService.recaptcha,
        secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
    )

    #expect(result, "reCaptcha should return success for test token")
}

@Test func invalidToken() async throws(CaptchaError) {
    let result = try await verifyCaptcha(
        "invalid-token",
        service: CaptchaService.turnstile,
        secret: "invalid secret"
    )

    #expect(!result, "Invalid token should not return success")
}
