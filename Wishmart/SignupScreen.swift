//
//  SignupScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI
import GoogleSignIn

struct SignupScreen: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        SignupView(
            onGoogleTap: {
                Task { await signInWithGoogle() }
            },
            onSignupTap: { name, email, pass in
                authVM.name = name
                authVM.email = email
                authVM.password = pass
                Task { await authVM.signup() }
            },
            onLoginTap: {
                authVM.goToLogin()
            }
        )
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
