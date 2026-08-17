import Foundation

extension HTTP {
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

            if let ip = ip {
                items.append(URLQueryItem(name: "remoteip", value: ip))
            }

            components.queryItems = items

            guard let query = components.query, let data = query.data(using: .utf8) else {
                throw .requestEncodingFailed
            }

            return data
        }
    }
}
