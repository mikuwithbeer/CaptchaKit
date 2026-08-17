import Foundation

extension HTTP {
    /// The normalized verification request sent to a provider.
    struct Request {
        let token: String
        let ip: String?

        init(token: String, ip: String?) {
            self.token = token
            self.ip = ip
        }

        func encode(with secret: String)
            throws(CaptchaKit.Error) -> Data
        {
            var parameters = [
                ("secret", secret),
                ("response", token),
            ]

            // Only include it when defined rather than sending an empty value.
            if let ip = ip {
                parameters.append(("remoteip", ip))
            }

            // Custom encoder that handles unsafe characters such as `&`, `=`, and `+`.
            let body =
                parameters
                .map { (key: String, value: String) -> String in
                    var encodedValue = ""
                    for byte in value.utf8 {
                        switch byte {
                        case 0x41...0x5A, 0x61...0x7A, 0x30...0x39,
                            0x2A, 0x2D, 0x2E, 0x5F:
                            encodedValue.append(Character(UnicodeScalar(byte)))
                        case 0x20:
                            encodedValue.append("+")
                        default:
                            encodedValue += String(format: "%%%02X", byte)
                        }
                    }

                    return "\(key)=\(encodedValue)"
                }
                .joined(separator: "&")

            guard let data = body.data(using: .utf8) else {
                throw .requestEncodingFailed
            }

            return data
        }
    }
}
