//
//  DealsViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 21/02/26.
//

import Foundation
internal import Combine

@MainActor
final class HomeDealsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func fetchBestDeals() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res: [Product] = try await APIClient.shared.request(
                path: "api/products/sale",
                method: "GET",
                responseType: [Product].self
            )
            products = res
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
