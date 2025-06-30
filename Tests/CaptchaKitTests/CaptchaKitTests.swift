import Testing

@testable import CaptchaKit

@Test func cloudflareTurnstile() async throws(CaptchaError) {
    print(
        try await verify(
            "always",
            service: CaptchaService.turnstile,
            secret: "1x0000000000000000000000000000000AA"
        ))
}
