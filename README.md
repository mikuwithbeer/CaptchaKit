# CaptchaKit

Lightweight and asynchronous Swift package for server-side verification of various CAPTCHA tokens.

## Services

- `Google reCAPTCHA`[^1]
- `hCaptcha`[^2]
- `Cloudflare Turnstile`[^3]

## Installation

Add `CaptchaKit` to your project's dependencies in `Package.swift`:

```swift
.package(url: "https://github.com/mikuwithbeer/CaptchaKit.git", from: "2.0.0")
```

## Usage

1. Create a reusable client instance:

   ```swift
   import CaptchaKit

   let client = CaptchaKit.Client(
     CaptchaKit.Config(
       strategy: .turnstile,
       secret: "your-secret-key"
     )
   )
   ```

2. Verify token with existing client:

   ```swift
   let isValid = await client.isValid("user-token")
   if !isValid {
       // Unauthorized!
   }
   ```

   Alternatively, you can verify with metadata:

   ```swift
   if let verification = try? await client.verifyDetails("user-token", ip: "100.200.255.1") {
       print("Verified for \(verification.host) at \(verification.date)")
   }
   ```

## Appendix

This project is licensed under the **BSD-2-Clause Plus Patent License**[^4].

[^1]: <https://developers.google.com/recaptcha>

[^2]: <https://www.hcaptcha.com>

[^3]: <https://www.cloudflare.com/products/turnstile/>

[^4]: <https://spdx.org/licenses/BSD-2-Clause-Patent.html>
