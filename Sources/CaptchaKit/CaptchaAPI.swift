import Foundation

/// The response structure returned by CAPTCHA verification services.
struct CaptchaResponseData: Decodable {
    let success: Bool
}

/// The data required to make a CAPTCHA verification request.
struct CaptchaRequestData {
    /// The secret key for your CAPTCHA service account.
    let secret: String
    /// The CAPTCHA token received from the client.
    let token: String
    /// The user's IP address.
    let remoteIP: String?

    /// Encodes the request data as `application/x-www-form-urlencoded` body.
    ///
    /// - Throws: ``CaptchaError.urlEncodingFailed`` if encoding fails,
    ///           ``CaptchaError.dataConversionFailed`` if data conversion fails.
    /// - Returns: The encoded request body as ``Data``.
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

/// Represents a CAPTCHA verification request.
final class CaptchaRequest {
    /// The CAPTCHA service to use.
    let service: CaptchaService
    /// The request data to send.
    let data: CaptchaRequestData

    /// Initializes a new CAPTCHA request class.
    ///
    /// - Parameters:
    ///   - service: The CAPTCHA service to use.
    ///   - data: The request data.
    init(service: CaptchaService, data: CaptchaRequestData) {
        self.service = service
        self.data = data
    }

    /// Creates a URLRequest for the CAPTCHA verification.
    ///
    /// - Throws: ``CaptchaError`` if the request body cannot be created.
    /// - Returns: A configured ``URLRequest``.
    func makeRequest() throws(CaptchaError) -> URLRequest {
        var request = URLRequest(url: service.url)

        request.httpMethod = "POST"
        request.httpBody = try data.toBody()

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return request
    }

    /// Sends the CAPTCHA verification request and returns the result.
    ///
    /// - Throws: ``CaptchaError`` if the request fails or the response cannot be decoded.
    /// - Returns: ``true`` if the CAPTCHA token is valid; otherwise, ``false``.
    func applyRequest() async throws(CaptchaError) -> Bool {
        let request = try makeRequest()

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(CaptchaResponseData.self, from: data)

            return response.success
        } catch let error as DecodingError {
            throw CaptchaError.jsonDecodeFailed(error)
        } catch let error as URLError {
            throw CaptchaError.urlError(error)
        } catch {
            throw CaptchaError.unknownError(error)
        }
    }
}
