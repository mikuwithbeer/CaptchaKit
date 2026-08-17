import Foundation

public struct CaptchaHTTPResponse: Decodable {
    public let verified: Bool

    let host: String?
    let timestamp: Date?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case verified = "success"

        case host = "hostname"
        case timestamp = "challenge_ts"
        case errors = "error-codes"
    }

    static public func load(from data: Data)
        throws(CaptchaError) -> Self
    {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
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
                debugDescription: "Malformed ISO 8601 Format: \(value)"
            )
        }

        do {
            return try decoder.decode(Self.self, from: data)
        } catch let error as DecodingError {
            throw .responseDecodingFailed(error)
        } catch {
            throw .unexpected(error)
        }
    }
}
