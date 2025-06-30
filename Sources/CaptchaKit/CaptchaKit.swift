public func verify(
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
