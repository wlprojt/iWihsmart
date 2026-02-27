//
//  OrderSuccessView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//
import SwiftUI

struct OrderSuccessView: View {
    var onDone: () -> Void = {}

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Order Successful!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Thank you for your purchase.")
                .foregroundStyle(.secondary)

            Button("Done", action: onDone)
                .buttonStyle(.borderedProminent)
                .padding(.top, 6)
        }
        .padding()
    }
}
