import CaptchaKit
import Testing

@Suite("CaptchaKit Client")
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
        let metadata = try await recaptchaClient.verifyWithMetadata(
            "valid-token-1",
            ip: nil
        )

        #expect(metadata != nil)
    }

    @Test("hCaptcha accepts valid test token")
    func hcaptchaAcceptsValidTestToken()
        async throws(CaptchaKit.Error)
    {
        let metadata = try await hcaptchaClient.verifyWithMetadata(
            "10000000-aaaa-bbbb-cccc-000000000001",
            ip: nil
        )

        #expect(metadata != nil)
    }

    @Test("hCaptcha rejects invalid test token")
    func hcaptchaRejectsInvalidTestToken()
        async throws(CaptchaKit.Error)
    {
        let success = await hcaptchaClient.verifyAsBool("10000000-dddd-bbbb-cccc-100000000001")
        #expect(!success)
    }

    @Test("Cloudflare Turnstile accepts valid test token")
    func turnstileAcceptsValidTestToken()
        async throws(CaptchaKit.Error)
    {
        let metadata = try await turnstileClient.verifyWithMetadata(
            "valid-token-2",
            ip: nil
        )

        #expect(metadata != nil)
    }
}
