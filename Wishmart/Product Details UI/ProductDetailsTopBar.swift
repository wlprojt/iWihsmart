//
//  ProductDetailsTopBar.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct ProductDetailsTopBar: View {

    @Environment(\.dismiss) private var dismiss

    var title: String = "Product Details"  // optional (if you want search)

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea(edges: .top)

            HStack(spacing: 12) {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Text(title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10) // push below status bar
        }
        .frame(height: 50)
    }

    
}

#Preview {
    NavigationStack {
        VStack(spacing: 0) {
            ProductDetailsTopBar()
            Spacer()
        }
    }
}
