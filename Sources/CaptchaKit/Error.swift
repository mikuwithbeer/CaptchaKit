import Foundation

public enum CaptchaError: Error {
    case requestEncodingFailed
    case responseDecodingFailed(DecodingError)
    case networkRequestFailed(Error)
}
