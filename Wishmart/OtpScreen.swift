//
//  OtpScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct OtpScreen: View {
    let email: String
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Verify OTP")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sent to \(email)")
                .foregroundColor(.gray)

            TextField("Enter OTP", text: $authVM.otp)
                .keyboardType(.numberPad)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4))
                )

            Button("Verify") {
                Task { await authVM.verifyOtp() }
            }
            .buttonStyle(.borderedProminent)

            Button("Resend OTP") {
                Task { await authVM.resendOtp() }
            }
            .foregroundColor(.blue)

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
