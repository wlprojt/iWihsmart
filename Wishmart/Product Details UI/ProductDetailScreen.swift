//
//  ProductDetailScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct ProductDetailScreen: View {

    let productId: String
    var onAddToCart: (Product) -> Void = { _ in }

    @StateObject private var vm = ProductDetailViewModel()
    @EnvironmentObject var cartVM: CartViewModel
    @State private var page = 0

    // ✅ navigation state
    @State private var selectedProductId: String? = nil

    var body: some View {
        VStack(spacing: 0) {

            // ✅ Fixed top bar
            ProductDetailsTopBar()

            Group {
                if vm.isLoading {
                    ProgressView("Loading...")
                        .padding()

                } else if let err = vm.errorMessage {
                    VStack(spacing: 10) {
                        Text(err).foregroundColor(.red)
                        Button("Retry") { Task { await vm.fetch(id: productId) } }
                    }
                    .padding()

                } else if let product = vm.product {
                    content(product: product)

                } else {
                    Text("No product found")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await vm.fetch(id: productId)
        }
        // ✅ Navigate on tap
        .navigationDestination(item: $selectedProductId) { id in
            ProductDetailScreen(productId: id, onAddToCart: onAddToCart)
        }
        .toolbar(.hidden, for: .navigationBar)      // ✅ hides system nav bar
            .navigationBarBackButtonHidden(true)   
    }

    // MARK: - UI Content (your same layout)
    private func content(product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {

                // Image pager
                TabView(selection: $page) {
                    ForEach(Array(product.images.enumerated()), id: \.offset) { idx, imgPath in
                        ZStack {
                            Color.gray.opacity(0.08)

                            if let url = imageURL(imgPath) {
                                AsyncImage(url: url) { img in
                                    img.resizable().scaledToFit().frame(width: 400, height: 400)
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(10)
                            } else {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                        .tag(idx)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 320)

                // Title
                Text(product.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black.opacity(0.85))
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                // Stock
                Text(stockText(product))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(product.stock > 0 ? .green : .red)
                    .padding(.horizontal, 16)

                // Rating
                HStack(spacing: 8) {
                    StarRow(rating: product.rating)
                    Text("(\(product.rating_count))")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)

                // Prices
                HStack(spacing: 14) {
                    if let sale = product.sale_price {
                        Text("$\(fmt(product.price))")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)
                            .strikethrough()

                        Text("$\(fmt(sale))")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black.opacity(0.85))
                    } else {
                        Text("$\(fmt(product.price))")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black.opacity(0.85))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                // Add to Cart
                Button {
                    Task {
                            await cartVM.add(productId: product.id, qty: 1)
                        }
                } label: {
                    Text("Add to Cart")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                }
                .buttonStyle(.plain)
                
                ProductInfoTabsCard(
                    descriptionText: product.description
                )
                
                RelatedProductsRow(
                    products: vm.relatedProducts,
                    onProductTap: { p in
                                            selectedProductId = p.id   // ✅ triggers navigation
                                        }
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stockText(_ product: Product) -> String {
        product.stock > 0 ? "In Stock (\(product.stock))" : "Out of Stock"
    }

    private func imageURL(_ path: String) -> URL? {
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            return URL(string: path)
        }
        let base = APIClient.shared.baseURL.absoluteString
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let p = path.hasPrefix("/") ? path : "/\(path)"
        return URL(string: base + p)
    }

    private func fmt(_ v: Double) -> String {
        String(format: "%.0f", v)
    }
}

// ✅ Needed for .navigationDestination(item:)
extension String: @retroactive Identifiable {
    public var id: String { self }
}


private struct StarRow: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 3) {
            let filled = Int(round(rating))
            ForEach(0..<5) { i in
                Image(systemName: i < filled ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
    }
}
