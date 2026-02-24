//
//  ProductModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 21/02/26.
//

import Foundation

struct Product: Identifiable, Codable {

    // Mongo ID
    let id: String

    // Core info
    let title: String
    let price: Double
    let sale_price: Double?
    let images: [String]

    // Details
    let description: String
    let features: [String]
    let category: String
    let stock: Int

    // Rating
    let rating: Double
    let rating_count: Int

    // Timestamps (optional but safe)
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
}
