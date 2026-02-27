//
//  AllProductsViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import Foundation
internal import Combine


@MainActor
final class AllProductsViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var total = 0
    @Published var page = 1
    @Published var pages = 1

    @Published var sort: ProductSort = .latest
    @Published var category: String = ""   // "" = All
    @Published var minPrice: Int = 0
    @Published var maxPrice: Int = 2000

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = ProductsService()
    private var isPaging = false

    func refresh() async {
        page = 1
        products = []
        await fetch(page: 1, append: false)
    }

    func applyFilters() async { await refresh() }

    func loadNextPageIfNeeded(currentItem: Product) async {
        guard !isPaging, page < pages, products.last?.id == currentItem.id else { return }
        isPaging = true
        defer { isPaging = false }
        await fetch(page: page + 1, append: true)
    }

    private func fetch(page: Int, append: Bool) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res = try await service.fetchAll(
                page: page,
                sort: sort,
                category: category.isEmpty ? nil : category, // ✅ key line
                minPrice: minPrice,
                maxPrice: maxPrice
            )

            total = res.total
            self.page = res.page
            pages = res.pages

            if append { products += res.products }
            else { products = res.products }

        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
