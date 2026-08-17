import Testing

@testable import CaptchaKit

@Test func turnstileSuccess()
    async throws(CaptchaError)
{
    let client = CaptchaClient(
        service: .turnstile,
        secret: "1x0000000000000000000000000000000AA"
    )

    let request = CaptchaRequest.init(token: "pass")
    let response = try await client.send(request)

    #expect(response.verified, "Turnstile should return success for test token")
}

@Test func hcaptchaSuccess()
    async throws(CaptchaError)
{
    let client = CaptchaClient(
        service: .hcaptcha,
        secret: "0x0000000000000000000000000000000000000000"
    )

    let request = CaptchaRequest.init(token: "10000000-aaaa-bbbb-cccc-000000000001")
    let response = try await client.send(request)

    #expect(response.verified, "hCaptcha should return success for test token")
}

@Test func recaptchaSuccess()
    async throws(CaptchaError)
{
    let client = CaptchaClient(
        service: .recaptcha,
        secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
    )

    let request = CaptchaRequest.init(token: "pass")
    let response = try await client.send(request)

    #expect(response.verified, "reCaptcha should return success for test token")
}
