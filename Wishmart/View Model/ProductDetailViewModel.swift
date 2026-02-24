//
//  ProductDetailViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import Foundation
internal import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {

    @Published var product: Product? = nil
    @Published var relatedProducts: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetch(id: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // 1) Fetch product
            let p: Product = try await APIClient.shared.request(
                path: "api/products/\(id)",
                method: "GET",
                responseType: Product.self
            )
            self.product = p

            // 2) Fetch related products by category (SAFE)
            let category = p.category.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !category.isEmpty else {
                self.relatedProducts = []
                return
            }

            let list: [Product] = try await APIClient.shared.request(
                path: "api/products",
                method: "GET",
                query: ["category": category],   // ✅ BEST
                responseType: [Product].self
            )

            self.relatedProducts = Array(
                list.filter { $0.id != p.id }.prefix(4)
            )

            // ✅ Debug
            print("✅ category:", category)
            print("✅ related count:", self.relatedProducts.count)

        } catch {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.relatedProducts = []
        }
    }
}
