import Foundation

struct CaptchaAPIResponse: Decodable {
    let success: Bool
}

struct CaptchaRequestData {
    var secret: String
    var token: String
    var remoteIP: String?

    func toBody() -> Data {
        let secretUri = self.secret.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let tokenUri = self.token.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        var body = Data()
        body.append("secret=\(secretUri)&response=\(tokenUri)".data(using: .utf8)!)

        if let remoteIP = self.remoteIP {
            let remoteIPUri = remoteIP.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)!
            body.append("&remoteip=\(remoteIPUri)".data(using: .utf8)!)
        }

        return body

    }
}

class CaptchaRequest {
    var service: CaptchaService
    var data: CaptchaRequestData
    var request: URLRequest?

    init(service: CaptchaService, data: CaptchaRequestData) {
        self.service = service
        self.data = data
    }

    func prepare() throws {
        let url = URL(string: self.service.getURL())!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.httpBody = self.data.toBody()

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        self.request = request
    }

    func apply() async throws -> Bool {
        let (data, _) = try await URLSession.shared.data(for: self.request!)
        let response = try JSONDecoder().decode(CaptchaAPIResponse.self, from: data)

        return response.success
    }
}
