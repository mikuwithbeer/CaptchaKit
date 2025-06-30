import Foundation

struct CaptchaAPIResponse: Decodable {
    let success: Bool
}

struct CaptchaRequestData {
    var secret: String
    var token: String
    var remoteIP: String?

    func toBody() throws(CaptchaError) -> Data {
        var components = URLComponents()

        components.queryItems = [
            URLQueryItem(name: "secret", value: secret),
            URLQueryItem(name: "response", value: token),
        ]

        if let remoteIP = remoteIP {
            components.queryItems?.append(URLQueryItem(name: "remoteip", value: remoteIP))
        }

        guard let query = components.query else {
            throw CaptchaError.urlEncodingFailed
        }

        guard let body = query.data(using: .utf8) else {
            throw CaptchaError.dataConversionFailed
        }

        return body
    }
}

class CaptchaRequest {
    let service: CaptchaService
    let data: CaptchaRequestData

    init(service: CaptchaService, data: CaptchaRequestData) {
        self.service = service
        self.data = data
    }

    func makeRequest() throws(CaptchaError) -> URLRequest {
        var request = URLRequest(url: service.url)

        request.httpMethod = "POST"
        request.httpBody = try data.toBody()

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return request
    }

    func applyRequest() async throws(CaptchaError) -> Bool {
        let request = try makeRequest()

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(CaptchaAPIResponse.self, from: data)

            return response.success
        } catch let error as DecodingError {
            throw CaptchaError.jsonDecodeFailed(error)
        } catch {
            throw CaptchaError.unknownError(error)
        }
    }
}
