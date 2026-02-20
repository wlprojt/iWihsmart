//
//  ToastView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.bottom, 40)
        }
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: message)
    }
}
