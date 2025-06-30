public enum CaptchaError: Error {
    case urlEncodingFailed
    case dataConversionFailed
    case jsonDecodeFailed(Error)
    case unknownError(Error)
}
