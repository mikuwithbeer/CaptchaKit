import Foundation

public struct CaptchaHTTPRequest {
    public let token: String
    public let ip: String?

    public init(token: String, ip: String? = nil) {
        self.token = token
        self.ip = ip
    }

    public func encode(with secret: String)
        throws(CaptchaError) -> Data
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
