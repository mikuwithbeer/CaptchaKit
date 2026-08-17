import Testing

@testable import CaptchaKit

@Suite("Captcha HTTP Client")
struct CaptchaHTTPClientTests {
    private let recaptchaClient = CaptchaHTTPClient(
        service: .recaptcha,
        secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
    )

    private let hcaptchaClient = CaptchaHTTPClient(
        service: .hcaptcha,
        secret: "0x0000000000000000000000000000000000000000"
    )

    private let turnstileClient = CaptchaHTTPClient(
        service: .turnstile,
        secret: "1x0000000000000000000000000000000AA"
    )

    @Test("Google reCAPTCHA accepts valid test token")
    func recaptchaAcceptsValidTestToken()
        async throws(CaptchaError)
    {
        let request = CaptchaHTTPRequest(token: "valid-token-1")
        let response = try await recaptchaClient.send(request)

        #expect(response.verified)
    }

    @Test("hCaptcha accepts valid test token")
    func hcaptchaAcceptsValidTestToken()
        async throws(CaptchaError)
    {
        let request = CaptchaHTTPRequest(token: "10000000-aaaa-bbbb-cccc-000000000001")
        let response = try await hcaptchaClient.send(request)

        #expect(response.verified)
    }

    @Test("hCaptcha rejects invalid test token")
    func hcaptchaRejectsInvalidTestToken()
        async throws(CaptchaError)
    {
        let request = CaptchaHTTPRequest(token: "10000000-bbbb-aaaa-cccc-000000000002")
        let response = try await hcaptchaClient.send(request)

        #expect(!response.verified)
    }

    @Test("Cloudflare Turnstile accepts valid test token")
    func turnstileAcceptsValidTestToken()
        async throws(CaptchaError)
    {
        let request = CaptchaHTTPRequest(token: "valid-token-2")
        let response = try await turnstileClient.send(request)

        #expect(response.verified)
    }
}
