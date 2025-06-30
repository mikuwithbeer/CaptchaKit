import Foundation

public enum CaptchaError: Error {
    case urlEncodingFailed
    case dataConversionFailed
    case jsonDecodeFailed(DecodingError)
    case urlError(URLError)
    case unknownError(Error)
}
