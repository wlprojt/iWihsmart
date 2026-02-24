//
//  CartAPI.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//


final class CartService {

    func fetchCart() async throws -> [CartItem] {
        let res: CartResponse = try await APIClient.shared.request(
            path: "api/cart",
            method: "GET",
            requiresAuth: true,
            responseType: CartResponse.self
        )
        return res.items
    }

    func addToCart(productId: String, qty: Int) async throws {
        _ = try await APIClient.shared.request(
            path: "api/cart",
            method: "POST",
            body: AddToCartRequest(productId: productId, qty: qty),
            requiresAuth: true,
            responseType: ApiResponse.self
        )
    }

    func updateQty(itemId: String, qty: Int) async throws {
        _ = try await APIClient.shared.request(
            path: "api/cart",
            method: "PUT",
            body: UpdateQtyRequest(id: itemId, qty: qty),
            requiresAuth: true,
            responseType: ApiResponse.self
        )
    }

    func removeItem(itemId: String) async throws {
        _ = try await APIClient.shared.request(
            path: "api/cart",
            method: "DELETE",
            body: RemoveItemRequest(id: itemId),
            requiresAuth: true,
            responseType: ApiResponse.self
        )
    }

    func fetchCount() async throws -> Int {
        let res: CartCountResponse = try await APIClient.shared.request(
            path: "api/cart/count",
            method: "GET",
            requiresAuth: true,
            responseType: CartCountResponse.self
        )
        return res.count
    }
}
