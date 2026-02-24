//
//  CartBadgeViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import Foundation
internal import Combine

// MARK: - Cart Badge VM (global)
@MainActor
final class CartBadgeViewModel: ObservableObject {
    @Published var count: Int = 0
    private let service = CartService()

    func refresh() async {
        do { count = try await service.fetchCount() }
        catch { count = 0 }
    }

    func clear() { count = 0 }
}
