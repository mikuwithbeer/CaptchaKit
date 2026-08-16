import Foundation

public struct CaptchaRequest {
    let token: String
    let ip: String?

    public func encode(secret: String) throws(CaptchaError) -> Data {
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
