//
//  ProductDetailView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct ProductDetailView: View {

    let productId: String

    var body: some View {
        VStack(spacing: 0) {
            ProductDetailScreen(productId: productId) { product in
                print("Add to cart:", product.id)
            }
        }
    }
}
