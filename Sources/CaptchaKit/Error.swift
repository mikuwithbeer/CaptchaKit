import Foundation

public enum CaptchaError: Error {
    case requestEncodingFailed
    case responseDecodingFailed(DecodingError)
    case networkFailure(any Error)
    case unexpected(any Error)
}
