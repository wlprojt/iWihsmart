//
//  LoginView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct LoginView: View {
    // Replace with your AuthViewModel later (EnvironmentObject)
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false

    var onGoogleTap: (() -> Void)? = nil
    var onLoginTap: ((_ email: String, _ password: String) -> Void)? = nil
    var onForgotPasswordTap: (() -> Void)? = nil
    var onSignUpTap: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer(minLength: 130)

                    CardContainer {
                        VStack(spacing: 18) {

                            // Title
                            VStack(spacing: 6) {
                                Text("Welcome back")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(Color.blue)

                                Text("Login to continue")
                                    .font(.system(size: 18, weight: .regular))
                                    .foregroundStyle(.gray)
                            }
                            .padding(.top, 8)

                            // Google Button
                            Button {
                                onGoogleTap?()
                            } label: {
                                HStack(spacing: 10) {
                                    Image("GoogleImage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 24)
                                    Text("Sign in with Google")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)
                            .background(Color(.systemGray3))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .disabled(isLoading)
                            .overlay {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }

                            // OR divider
                            HStack(spacing: 14) {
                                Divider().background(Color.gray.opacity(0.5))
                                Text("OR")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.gray)
                                Divider().background(Color.gray.opacity(0.5))
                            }
                            .padding(.top, 4)

                            // Email field
                            StyledTextField(
                                placeholder: "Email",
                                text: $email,
                                isSecure: false,
                                rightIcon: nil,
                                onRightIconTap: nil
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)

                            // Password field with eye
                            StyledTextField(
                                placeholder: "Password",
                                text: $password,
                                isSecure: !isPasswordVisible,
                                rightIcon: isPasswordVisible ? "eye.slash" : "eye",
                                onRightIconTap: { isPasswordVisible.toggle() }
                            )
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)

                            // Forgot password
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    onForgotPasswordTap?()
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.blue)
                                .disabled(isLoading)
                            }
                            .padding(.top, -4)

                            // Login button
                            Button {
                                onLoginTap?(email.trimmingCharacters(in: .whitespacesAndNewlines), password)
                            } label: {
                                Text("Login")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                            .buttonStyle(.plain)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .disabled(isLoading || email.isEmpty || password.isEmpty)

                            // Bottom text
                            HStack(spacing: 6) {
                                Text("Don’t have an account?")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 18, weight: .regular))

                                Button("Sign up") {
                                    onSignUpTap?()
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.blue)
                                .disabled(isLoading)
                            }
                            .padding(.top, 6)

                        }
                        .padding(22)
                    }
                    .padding(.horizontal, 18)

                    Spacer(minLength: 40)
                }
            }
        }
    }
}

// MARK: - Card Container

private struct CardContainer<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 18, x: 0, y: 10)
    }
}

// MARK: - Styled TextField

private struct StyledTextField: View {
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
            .font(.system(size: 18, weight: .regular))
            .foregroundStyle(Color(.label))
            .padding(.vertical, 14)

            if let rightIcon {
                Button {
                    onRightIconTap?()
                } label: {
                    Image(systemName: rightIcon)
                        .foregroundStyle(Color.gray)
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

// MARK: - Preview

#Preview {
    LoginView(
        onGoogleTap: { print("Google") },
        onLoginTap: { email, pass in print("Login:", email, pass) },
        onForgotPasswordTap: { print("Forgot") },
        onSignUpTap: { print("Sign Up") }
    )
}
