//
//  ProductModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 21/02/26.
//

import Foundation

struct ProductsPageResponse: Decodable {
    let products: [Product]
    let total: Int
    let page: Int
    let pages: Int
}

struct Product: Identifiable, Codable {

    let id: String
    let title: String
    let price: Double
    let sale_price: Double?
    let images: [String]

    let description: String
    let features: [String]
    let category: String
    let stock: Int

    let rating: Double
    let rating_count: Int

    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case price
        case sale_price
        case images
        case description
        case features
        case category
        case stock
        case rating
        case rating_count
        case createdAt
        case updatedAt
    }

    // ✅ Safe decoding (prevents "only Audio & Video not showing" issue)
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = try c.decode(String.self, forKey: .id)
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        price = try c.decodeIfPresent(Double.self, forKey: .price) ?? 0
        sale_price = try c.decodeIfPresent(Double.self, forKey: .sale_price)

        // IMPORTANT: tolerate null/missing images/features/description
        images = try c.decodeIfPresent([String].self, forKey: .images) ?? []
        description = try c.decodeIfPresent(String.self, forKey: .description) ?? ""
        features = try c.decodeIfPresent([String].self, forKey: .features) ?? []

        category = try c.decodeIfPresent(String.self, forKey: .category) ?? ""
        stock = try c.decodeIfPresent(Int.self, forKey: .stock) ?? 0

        rating = try c.decodeIfPresent(Double.self, forKey: .rating) ?? 0
        rating_count = try c.decodeIfPresent(Int.self, forKey: .rating_count) ?? 0

        createdAt = try c.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try c.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
