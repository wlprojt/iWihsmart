//
//  AudioVideoViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 21/02/26.
//

import Foundation
internal import Combine

@MainActor
final class AudioVideoViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res: [Product] = try await APIClient.shared.request(
                path: "api/products",
                method: "GET",
                query: ["category": "Audio & Video"],
                responseType: [Product].self
            )
            products = res
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
