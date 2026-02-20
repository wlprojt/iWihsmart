//
//  AuthService.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 19/02/26.
//

import Foundation

final class AuthService {
    private let api = APIClient.shared

    func signUp(name: String, email: String, password: String) async throws {
        _ = try await api.request(
            path: "api/auth/signup",
            method: "POST",
            body: SignUpRequest(name: name, email: email, password: password),
            responseType: EmptyResponse.self
        )
    }

    func signIn(email: String, password: String) async throws -> TokenResponse {
        try await api.request(
            path: "api/auth/login",
            method: "POST",
            body: AuthRequest(email: email, password: password),
            responseType: TokenResponse.self
        )
    }

    func verifyOtp(email: String, otp: String) async throws -> OtpResponse {
        try await api.request(
            path: "api/auth/verify-otp",
            method: "POST",
            body: VerifyOtpRequest(email: email, otp: otp),
            responseType: OtpResponse.self
        )
    }

    func resendOtp(email: String) async throws {
        _ = try await api.request(
            path: "api/auth/resend-otp",
            method: "POST",
            body: ResendOtpRequest(email: email),
            responseType: EmptyResponse.self
        )
    }

    func forgotPassword(email: String) async throws {
        _ = try await api.request(
            path: "api/auth/forgot-password",
            method: "POST",
            body: ForgotPasswordRequest(email: email),
            responseType: EmptyResponse.self
        )
    }

    func googleLogin(idToken: String) async throws -> GoogleLoginResponse {
        try await api.request(
            path: "api/auth/google-login",
            method: "POST",
            body: GoogleLoginRequest(idToken: idToken),
            responseType: GoogleLoginResponse.self
        )
    }

    func me() async throws -> UserMeResponse {
        try await api.request(
            path: "api/auth/me",
            method: "GET",
            requiresAuth: true,
            responseType: UserMeResponse.self
        )
    }
}

struct EmptyResponse: Codable {}

struct UserMeResponse: Codable {
    let id: String
    let name: String
    let email: String
    let emailVerified: Bool
    let createdAt: String
}
