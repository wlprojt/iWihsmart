//
//  ForgotPasswordView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct ForgotPasswordView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer(minLength: 200)

                    WishCard {
                        VStack(spacing: 20) {

                            VStack(spacing: 6) {
                                Text("Forgot Password")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(Color.blue)

                                Text("We’ll send you a reset link")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.gray)
                            }

                            WishTextField(
                                placeholder: "Email",
                                text: $email,
                                isSecure: false,
                                rightIcon: nil,
                                onRightIconTap: nil
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)

                            Button {
                                authVM.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                                Task { await authVM.sendResetLink() }
                            } label: {
                                Text("Send reset link")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                            .buttonStyle(.plain)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .disabled(authVM.isLoading || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                            Button {
                                dismiss()
                            } label: {
                                Text("Back to Login")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(.top, 2)

                            if let error = authVM.errorMessage {
                                Text(error)
                                    .foregroundStyle(.red)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(22)
                    }
                    .padding(.horizontal, 18)

                    Spacer(minLength: 40)
                }
            }

            if authVM.isLoading {
                Color.black.opacity(0.2).ignoresSafeArea()
                ProgressView().scaleEffect(1.2)
            }
        }
    }
}

// MARK: - Reusable components (self-contained)

private struct WishCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 18, x: 0, y: 10)
    }
}

private struct WishTextField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let rightIcon: String?
    let onRightIconTap: (() -> Void)?

    var body: some View {
        HStack {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 18))
            .foregroundStyle(Color(.label))
            .padding(.vertical, 14)

            if let rightIcon {
                Button {
                    onRightIconTap?()
                } label: {
                    Image(systemName: rightIcon)
                        .foregroundStyle(.gray)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.leading, 6)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel())
}
