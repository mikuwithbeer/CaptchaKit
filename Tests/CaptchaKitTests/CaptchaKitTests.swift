import CaptchaKit
import Testing

@Suite("CaptchaKit Public API")
struct CaptchaKitTests {
    private let recaptchaClient = CaptchaKit.Client(
        CaptchaKit.Config(
            strategy: .recaptcha,
            secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
        )
    )

    private let hcaptchaClient = CaptchaKit.Client(
        CaptchaKit.Config(
            strategy: .hcaptcha,
            secret: "0x0000000000000000000000000000000000000000"
        )
    )

    private let turnstileClient = CaptchaKit.Client(
        CaptchaKit.Config(
            strategy: .turnstile,
            secret: "1x0000000000000000000000000000000AA"
        )
    )

    @Test("Google reCAPTCHA accepts valid test token")
    func recaptchaAcceptsValidTestToken()
        async throws(CaptchaKit.Error)
    {
        let verification = try await recaptchaClient.verifyDetails(
            "valid-token-1",
            ip: nil
        )

        #expect(verification != nil)
    }

    @Test("hCaptcha accepts valid test token")
    func hcaptchaAcceptsValidTestToken()
        async throws(CaptchaKit.Error)
    {
        let verification = try await hcaptchaClient.verifyDetails(
            "10000000-aaaa-bbbb-cccc-000000000001",
            ip: nil
        )

        #expect(verification != nil)
    }

    @Test("hCaptcha rejects invalid test token")
    func hcaptchaRejectsInvalidTestToken()
        async throws(CaptchaKit.Error)
    {
        let isValid = await hcaptchaClient.isValid(
            "10000000-dddd-bbbb-cccc-100000000001"
        )

        #expect(!isValid)
    }

    @Test("Cloudflare Turnstile accepts valid test token")
    func turnstileAcceptsValidTestToken()
        async throws(CaptchaKit.Error)
    {
        let isValid = await turnstileClient.isValid(
            "valid-token-2"
        )

        #expect(isValid)
    }
}
