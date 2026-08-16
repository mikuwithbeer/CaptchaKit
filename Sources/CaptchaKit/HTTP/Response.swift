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

    static func dateDecoder(decoder: any Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        let formats = [
            Date.ISO8601FormatStyle(includingFractionalSeconds: false),
            Date.ISO8601FormatStyle(includingFractionalSeconds: true),
        ]

        for format in formats {
            if let date = try? format.parse(value) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Invalid date: \(value)"
        )
    }
}
