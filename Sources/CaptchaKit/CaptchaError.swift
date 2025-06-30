import Foundation

/// Errors that can occur during CAPTCHA verification.
public enum CaptchaError: Error {
    /// Failed to encode URL parameters.
    case urlEncodingFailed
    /// Failed to convert data to the required format.
    case dataConversionFailed
    /// Failed to decode the JSON response.
    case jsonDecodeFailed(DecodingError)
    /// A URL-related error occurred during the request.
    case urlError(URLError)
    /// An unknown error occurred.
    case unknownError(Error)
}
