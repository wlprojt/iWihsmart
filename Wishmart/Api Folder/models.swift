//
//  models.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 19/02/26.
//

import Foundation

// MARK: - Models (match your backend)

struct AuthRequest: Codable {
    let email: String
    let password: String
}

struct SignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct VerifyOtpRequest: Codable {
    let email: String
    let otp: String
}

struct ResendOtpRequest: Codable {
    let email: String
}

struct ForgotPasswordRequest: Codable {
    let email: String
}

struct TokenResponse: Codable {
    let token: String
    let user: UserDto
}

struct UserDto: Codable {
    let id: String
    let email: String
}

struct OtpResponse: Codable {
    let ok: Bool
    let token: String
}

struct GoogleLoginRequest: Codable {
    let idToken: String
}

struct GoogleUserDto: Codable {
    let id: String
    let name: String
    let email: String
}

struct GoogleLoginResponse: Codable {
    let token: String
    let user: GoogleUserDto
}

