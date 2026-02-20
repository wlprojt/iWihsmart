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
    case login
    case signup
    case otp(email: String)
    case home
}

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - UI State
    @Published var step: AuthFlowStep = .login

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var toastMessage: String? = nil

    // Form fields (optional — you can keep fields inside Views too)
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var otp: String = ""

    // Logged in user
    @Published var userEmail: String? = nil

    private let service = AuthService()

    init() {
        // If token exists, try to validate
        if KeychainStore.shared.getToken()?.isEmpty == false {
            Task { await self.bootstrapAuth() }
        }
    }

    // MARK: - Startup check
    func bootstrapAuth() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let me = try await service.me()
            userEmail = me.email
            step = .home
        } catch {
            KeychainStore.shared.clearToken()
            step = .login
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
            toastMessage = "Login Successful"
            step = .home
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Login failed"
        }
    }

    // MARK: - Signup (OTP sent)
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

    // MARK: - Verify OTP (returns JWT)
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

    // MARK: - Forgot password
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

    // MARK: - Google login (idToken from GoogleSignIn SDK)
    func googleLogin(idToken: String) async {
        guard !idToken.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res = try await service.googleLogin(idToken: idToken)
            KeychainStore.shared.saveToken(res.token)
            userEmail = res.user.email
            toastMessage = "Login Successful"
            step = .home
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Google login failed"
        }
    }

    // MARK: - Logout
    func logout() {
        KeychainStore.shared.clearToken()
        userEmail = nil
        name = ""
        email = ""
        password = ""
        otp = ""
        step = .login
    }

    // MARK: - Navigation helpers
    func goToLogin() { step = .login }
    func goToSignup() { step = .signup }
}
