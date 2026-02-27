//
//  AllProductsAPI.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import Foundation

enum ProductSort: String, CaseIterable, Identifiable {
    case latest = "latest"
    case rating = "rating"
    case priceAsc = "price-asc"
    case priceDesc = "price-desc"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .latest: return "Latest"
        case .rating: return "Top Rated"
        case .priceAsc: return "Price: Low → High"
        case .priceDesc: return "Price: High → Low"
        }
    }
}

final class ProductsService {
    func fetchAll(
        page: Int,
        sort: ProductSort,
        category: String?,
        minPrice: Int,
        maxPrice: Int
    ) async throws -> ProductsPageResponse {

        var query: [String: String] = [
            "page": String(page),
            "sort": sort.rawValue,
            "minPrice": String(minPrice),
            "maxPrice": String(maxPrice)
        ]

        if let category, !category.isEmpty {
            query["category"] = category
        }

        // ✅ IMPORTANT: use query helper (no %3F bug)
        let res: ProductsPageResponse = try await APIClient.shared.request(
            path: "api/products/all",
            method: "GET",
            query: query,
            responseType: ProductsPageResponse.self
        )

        return res
    }
}
