import Foundation

public struct CaptchaResponse: Decodable {
    let verified: Bool

    let host: String?
    let timestamp: Date?

    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case verified = "success"

        case host = "hostname"
        case timestamp = "challenge_ts"

        case errors = "error-codes"
    }
}
