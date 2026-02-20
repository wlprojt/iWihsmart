//
//  ContentView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 19/02/26.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        ZStack {
            switch authVM.step {

            case .login:
                LoginScreen()

            case .signup:
                SignupScreen()

            case .otp(let email):
                OtpScreen(email: email)

            case .home:
                HomeView()
            }

            // 🔔 Toast / error overlay
            if let message = authVM.toastMessage {
                ToastView(message: message)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            authVM.toastMessage = nil
                        }
                    }
            }
        }
    }
}
