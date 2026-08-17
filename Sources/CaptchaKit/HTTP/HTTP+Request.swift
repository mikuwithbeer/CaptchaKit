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
            var components = URLComponents()
            var items = [
                URLQueryItem(name: "secret", value: secret),
                URLQueryItem(name: "response", value: token),
            ]

            // Only include it when defined rather than sending an empty value.
            if let ip = ip {
                items.append(URLQueryItem(name: "remoteip", value: ip))
            }

            components.queryItems = items

            // TODO: Replace this with proper form encoding!
            guard let query = components.query, let data = query.data(using: .utf8) else {
                throw .requestEncodingFailed
            }

            return data
        }
    }
}
