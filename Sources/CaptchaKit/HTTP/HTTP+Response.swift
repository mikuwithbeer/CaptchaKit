import Foundation

extension HTTP {
    /// The normalized verification response returned by a provider.
    struct Response: Decodable {
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

        static func decode(from data: Data)
            throws(CaptchaKit.Error) -> Self
        {
            let decoder = JSONDecoder()

            // Parsing the known provider formats ourselves keeps verification behavior consistent across supported toolchains.
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

                // Throw a decoding error here for other cases.
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
                // Anything outside normal decoding failures is unexpected here.
                // Retain the underlying error rather than losing its context.
                throw .unexpected(error)
            }
        }
    }
}
