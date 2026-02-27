//
//  SaleProductsViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import Foundation
internal import Combine

@MainActor
final class SaleProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res: [Product] = try await APIClient.shared.request(
                path: "api/products/sale",
                method: "GET",
                responseType: [Product].self
            )
            self.products = res
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
