//
//  ProfileView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome 🎉")
                .font(.largeTitle)

            if let email = authVM.userEmail {
                Text(email)
                    .foregroundColor(.gray)
            }

            Button("Logout") {
                authVM.logout()
            }
            .foregroundColor(.red)
        }
    }
}
