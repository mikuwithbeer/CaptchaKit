/// Verifies a CAPTCHA token with the specified service and secret key.
///
/// This function sends the provided CAPTCHA token to the selected verification
/// service and returns whether the token is valid.
///
/// - Parameters:
///   - token: The CAPTCHA token received from the client.
///   - service: The CAPTCHA service to use for verification.
///   - secret: The secret key for your CAPTCHA service account.
///   - remoteIP: The user's IP address.
///
/// - Throws: ``CaptchaError`` if the verification request fails.
/// - Returns: `true` if the CAPTCHA token is valid; otherwise, `false`.
public func verifyCaptcha(
    _ token: String,
    service: CaptchaService,
    secret: String,
    remoteIP: String? = nil
) async throws(CaptchaError) -> Bool {
    let request = CaptchaRequest(
        service: service,
        data:
            CaptchaRequestData(
                secret: secret,
                token: token,
                remoteIP: remoteIP
            )
    )

    return try await request.applyRequest()
}
