//
//  CartModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import Foundation

// MARK: - API Generic Response
struct ApiResponse: Decodable {
    let ok: Bool?
    let error: String?
}

// MARK: - Cart Count
struct CartCountResponse: Decodable {
    let count: Int
}

// MARK: - Cart Response
struct CartResponse: Decodable {
    let items: [CartItem]
}

// MARK: - Cart Item
struct CartItem: Identifiable, Decodable {
    let _id: String
    let productId: String
    let title: String
    let price: Double
    let sale_price: Double?
    let image: String?
    let stock: Int
    let qty: Int

    var id: String { _id }
}

// MARK: - Requests
struct AddToCartRequest: Encodable {
    let productId: String
    let qty: Int
}

struct UpdateQtyRequest: Encodable {
    let id: String
    let qty: Int
}

struct RemoveItemRequest: Encodable {
    let id: String
}
