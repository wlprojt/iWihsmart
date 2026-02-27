//
//  SearchModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import Foundation

struct ProductSuggestion: Identifiable, Decodable {
    let id: String
    let title: String
    let images: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case images
    }
}
