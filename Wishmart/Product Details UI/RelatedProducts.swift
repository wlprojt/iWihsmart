//
//  RelatedProducts.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import SwiftUI

// MARK: - Related Products (horizontal, like screenshot)
struct RelatedProductsRow: View {

    let products: [Product]

    var onProductTap: (Product) -> Void = { _ in }

    private var displayed: [Product] { Array(products.prefix(20)) } // you can keep 4 if you want

    var body: some View {
        if displayed.isEmpty { EmptyView() }
        else {
            VStack(alignment: .leading, spacing: 12) {

                Text("Related Products")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black.opacity(0.85))
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(displayed) { p in
                            Button {
                                onProductTap(p)
                            } label: {
                                RelatedProductCard(product: p)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
        }
    }
}

// MARK: - Card (matches screenshot style)
private struct RelatedProductCard: View {

    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // image area
            ZStack {
                Color.gray.opacity(0.08)

                if let url = productImageURL(product) {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(14)
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            .frame(height: 170)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            // rating
            HStack(spacing: 6) {
                GoldenStarRating(value: product.rating)
                Text("(\(product.rating_count))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }

            // title
            Text(product.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black.opacity(0.85))
                .lineLimit(2)
                .frame(minHeight: 44, alignment: .top)

            // prices
            HStack(spacing: 10) {
                if let sale = product.sale_price {
                    Text("$\(fmt(product.price))")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .strikethrough()

                    Text("$\(fmt(sale))")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                } else {
                    Text("$\(fmt(product.price))")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(width: 230, height: 320)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 7)
    }

    // ✅ supports Cloudinary full url or local /uploads path
    private func productImageURL(_ product: Product) -> URL? {
        guard let first = product.images.first else { return nil }

        if first.hasPrefix("http://") || first.hasPrefix("https://") {
            return URL(string: first)
        }

        let base = APIClient.shared.baseURL.absoluteString
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let path = first.hasPrefix("/") ? first : "/\(first)"
        return URL(string: base + path)
    }

    private func fmt(_ v: Double) -> String {
        String(format: "%.0f", v)
    }
}

// MARK: - Golden Stars (same idea as your web)
struct GoldenStarRating: View {
    let value: Double // 0...5

    var body: some View {
        HStack(spacing: 2) {
            let filled = Int(round(value))
            ForEach(0..<5) { i in
                Image(systemName: i < filled ? "star.fill" : "star")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.yellow)
            }
        }
    }
}

