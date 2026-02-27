//
//  AuthViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 19/02/26.
//

import Foundation
import SwiftUI
internal import Combine

enum AuthFlowStep: Equatable {
    case booting
    case login
    case signup
    case otp(email: String)
    case home
}

@MainActor
final class AuthViewModel: ObservableObject {

    // ✅ start with booting so login won't flash
    @Published var step: AuthFlowStep = .booting

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var toastMessage: String? = nil

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var otp: String = ""

    @Published var userEmail: String? = nil

    private let service = AuthService()

    init() {
        // ✅ always bootstrap once on app start
        Task { await self.bootstrapAuth() }
    }

    func bootstrapAuth() async {
        isLoading = true
        defer { isLoading = false }

        let token = KeychainStore.shared.getToken()
        print("BOOT token:", token ?? "nil")

        guard let token, !token.isEmpty else {
            step = .login
            return
        }

        // ✅ show cached email instantly
        if let cached = LocalUserStore.getEmail(), !cached.isEmpty {
            userEmail = cached
        }

        step = .home

        do {
            let me = try await service.me()
            userEmail = me.email
            LocalUserStore.saveEmail(me.email) // ✅ keep updated
            print("BOOT me ok:", me.email)
        } catch let apiErr as APIError {
            print("BOOT me failed:", apiErr.localizedDescription)

            if case .http(let code, _) = apiErr, code == 401 {
                KeychainStore.shared.clearToken()
                LocalUserStore.clear()        // ✅ clear cached email too
                userEmail = nil
                step = .login
            }
        } catch {
            print("BOOT me failed (network):", error.localizedDescription)
            // offline -> keep cached email
        }
    }

    // MARK: - Email Login
    func login() async {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanEmail.isEmpty, !password.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res = try await service.signIn(email: cleanEmail, password: password)
            KeychainStore.shared.saveToken(res.token)
            userEmail = res.user.email
            LocalUserStore.saveEmail(res.user.email)
            toastMessage = "Login Successful"
            step = .home
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Login failed"
        }
    }

    func signup() async {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty, !cleanEmail.isEmpty, !password.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await service.signUp(name: name, email: cleanEmail, password: password)
            toastMessage = "OTP Sent"
            step = .otp(email: cleanEmail)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Signup failed"
        }
    }

    func verifyOtp() async {
        guard case .otp(let otpEmail) = step else { return }
        guard !otp.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res = try await service.verifyOtp(email: otpEmail, otp: otp)
            if res.ok {
                KeychainStore.shared.saveToken(res.token)
                userEmail = otpEmail
                LocalUserStore.saveEmail(otpEmail)
                toastMessage = "OTP Verified"
                step = .home
            } else {
                errorMessage = "Invalid OTP"
            }
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "OTP verify failed"
        }
    }

    func resendOtp() async {
        guard case .otp(let otpEmail) = step else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await service.resendOtp(email: otpEmail)
            toastMessage = "OTP Resent"
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Resend OTP failed"
        }
    }

    func sendResetLink() async {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanEmail.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await service.forgotPassword(email: cleanEmail)
            toastMessage = "Reset link sent"
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to send reset link"
        }
    }

    func googleLogin(idToken: String) async {
        guard !idToken.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res = try await service.googleLogin(idToken: idToken)
            KeychainStore.shared.saveToken(res.token)
            userEmail = res.user.email
            LocalUserStore.saveEmail(res.user.email)
            toastMessage = "Login Successful"
            step = .home
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Google login failed"
        }
    }

    func logout() {
        KeychainStore.shared.clearToken()
        userEmail = nil
        LocalUserStore.clear()
        name = ""
        email = ""
        password = ""
        otp = ""
        step = .login
    }

    func goToLogin() { step = .login }
    func goToSignup() { step = .signup }
}
