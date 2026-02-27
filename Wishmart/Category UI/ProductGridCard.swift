//
//  ProductGridCard.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import SwiftUI

struct ProductGridCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ZStack {
                Color.gray.opacity(0.08)

                if let url = imageURL {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(10)
                } else {
                    Image(systemName: "photo").foregroundColor(.gray.opacity(0.6))
                }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Text(product.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.85))
                .lineLimit(2)

            HStack(spacing: 8) {
                if let sale = product.sale_price {
                    Text("$\(product.price, specifier: "%.0f")")
                        .foregroundColor(.gray)
                        .strikethrough()
                    Text("$\(sale, specifier: "%.0f")")
                        .fontWeight(.bold)
                } else {
                    Text("$\(product.price, specifier: "%.0f")")
                        .fontWeight(.bold)
                }
            }
            .font(.system(size: 14))
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private var imageURL: URL? {
        guard let first = product.images.first else { return nil }
        if first.hasPrefix("http") { return URL(string: first) }

        let base = APIClient.shared.baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let path = first.hasPrefix("/") ? first : "/\(first)"
        return URL(string: base + path)
    }
}
