//
//  ProductsAllViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import Foundation
internal import Combine

@MainActor
final class ProductsAllViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    @Published var page: Int = 1
    @Published var pages: Int = 1
    @Published var total: Int = 0

    // filters
    @Published var sort: ProductSort? = .latest
    @Published var category: String? = nil
    @Published var minPrice: Int = 0
    @Published var maxPrice: Int = 2000

    private let service: ProductsService

    init(service: ProductsService = ProductsService()) {
        self.service = service
    }

    func refresh() async {
        page = 1
        products = []
        await loadMoreIfNeeded(currentItem: nil, force: true)
    }

    func loadMoreIfNeeded(currentItem: Product?, force: Bool = false) async {
        if isLoading { return }
        if !force {
            // load more when near bottom
            if let currentItem,
               let idx = products.firstIndex(where: { $0.id == currentItem.id }) {
                if idx < products.count - 4 { return }
            }
            if page > pages { return }
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res = try await service.fetchAll(
                page: page,
                sort: sort!,
                category: category,
                minPrice: minPrice,
                maxPrice: maxPrice
            )

            self.total = res.total
            self.pages = res.pages

            if page == 1 {
                self.products = res.products
            } else {
                self.products.append(contentsOf: res.products)
            }

            self.page += 1
        } catch {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
