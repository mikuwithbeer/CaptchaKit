extension CaptchaKit {
    /// Errors that can occur while verifying a challenge.
    public enum Error: Swift.Error {
        case requestEncodingFailed
        case responseDecodingFailed(DecodingError)
        case responseFailure
        case networkFailure(any Swift.Error)
        case strategyFailure([String])
        case unexpected(any Swift.Error)
    }
}
