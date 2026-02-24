//
//  CartViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import SwiftUI
internal import Combine

@MainActor
final class CartViewModel: ObservableObject {

    @Published var items: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: CartService

    init(service: CartService = CartService()) {
        self.service = service
    }

    func fetchCart() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            items = try await service.fetchCart()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func add(productId: String, qty: Int = 1) async {
        do {
            try await service.addToCart(productId: productId, qty: qty)
            await fetchCart()
        } catch {
            print("Add failed:", error)
        }
    }

    func updateQty(itemId: String, qty: Int) async {
        guard qty > 0 else { return }
        do {
            try await service.updateQty(itemId: itemId, qty: qty)
            await fetchCart()
        } catch {
            print("Update failed:", error)
        }
    }

    func remove(itemId: String) async {
        do {
            try await service.removeItem(itemId: itemId)
            await fetchCart()
        } catch {
            print("Remove failed:", error)
        }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + (($1.sale_price ?? $1.price) * Double($1.qty)) }
    }
}
