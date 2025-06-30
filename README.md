# CaptchaKit

Lightweight and asynchronous Swift package for server-side verification of various captcha tokens.

## Services
- Google reCAPTCHA
- hCaptcha
- Cloudflare Turnstile

## Installation
Add `CaptchaKit` to your project's dependencies in `Package.swift`:

```swift
.package(url: "https://github.com/mikuwithbeer/CaptchaKit.git", from: "0.0.0")
```

## Usage

```swift
import CaptchaKit

let isValid = try await verifyCaptcha(
    "user-token",
    service: .turnstile,
    secret: "your-secret-key"
)

if isValid {
    // Token is valid
} else {
    // Token is invalid
}
```
