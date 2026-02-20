//
//  LoginScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI
import GoogleSignIn

struct LoginScreen: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showForgot = false

    var body: some View {
        LoginView(
            onGoogleTap: {
                Task { await signInWithGoogle() }
            },
            onLoginTap: { email, pass in
                authVM.email = email
                authVM.password = pass
                Task { await authVM.login() }
            },
            onForgotPasswordTap: {
                showForgot = true
            },
            onSignUpTap: {
                authVM.goToSignup()
            }
        )
        .sheet(isPresented: $showForgot) {
            ForgotPasswordView()
                .environmentObject(authVM)
        }
    }

    private func signInWithGoogle() async {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            await MainActor.run { authVM.errorMessage = "No root view controller" }
            return
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            guard let idToken = result.user.idToken?.tokenString else {
                await MainActor.run { authVM.errorMessage = "No idToken received" }
                return
            }

            await authVM.googleLogin(idToken: idToken)
        } catch {
            await MainActor.run { authVM.errorMessage = "Google Sign-In failed" }
        }
    }
}
