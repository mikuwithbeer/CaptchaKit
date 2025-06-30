public func verify(
    _ token: String,
    service: CaptchaService,
    secret: String,
    remoteIP: String? = nil
) async throws -> Bool {
    let verifier = CaptchaRequest(
        service: service,
        data:
            CaptchaRequestData(
                secret: secret,
                token: token,
                remoteIP: remoteIP
            )
    )

    try verifier.prepare()
    return try await verifier.apply()
}
