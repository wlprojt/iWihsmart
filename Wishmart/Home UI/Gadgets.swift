//
//  Gadgets.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct GadgetsSection: View {

    @StateObject private var vm = GadgetsViewModel()

    var onSeeMore: () -> Void = {}
    var onProductTap: (Product) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack {
                Text("Gadgets")
                    .padding(.top, 10)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black.opacity(0.85))
                
                Spacer()

                Button("See more", action: onSeeMore)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)
                    .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)

            // Content
            if vm.isLoading {
                ProgressView()
                    .padding(.horizontal, 16)

            } else if let err = vm.errorMessage {
                VStack(alignment: .leading, spacing: 8) {
                    Text(err)
                        .foregroundColor(.red)

                    Button("Retry") {
                        Task { await vm.fetch() }
                    }
                }
                .padding(.horizontal, 16)

            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(vm.products) { p in
                            Button {
                                onProductTap(p)
                            } label: {
                                GadgetsProductCard(product: p)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.white)
        .task {
            if vm.products.isEmpty {
                await vm.fetch()
            }
        }
    }
}


private struct GadgetsProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Image
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
            .frame(width: 190, height: 170)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            // Rating row
            HStack(spacing: 6) {
                StarRow(rating: product.rating)
                Text("(\(product.rating_count))")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }

            // Title
            Text(product.title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.black.opacity(0.85))
                .lineLimit(2)

            // Price row
            HStack(spacing: 10) {
                if let sale = product.sale_price {
                    Text("$\(format(product.price))")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .strikethrough()

                    Text("$\(format(sale))")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                } else {
                    Text("$\(format(product.price))")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(width: 220, height: 320)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 7)
    }

    // ✅ Works for Cloudinary full URL AND local /uploads paths
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

    private func format(_ v: Double) -> String {
        String(format: "%.0f", v)
    }
}

private struct StarRow: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 2) {
            let filled = Int(round(rating))
            ForEach(0..<5) { i in
                Image(systemName: i < filled ? "star.fill" : "star")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.yellow)
            }
        }
    }
}
