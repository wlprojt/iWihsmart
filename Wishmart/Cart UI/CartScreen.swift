//
//  CartScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import SwiftUI

struct CartScreen: View {

    @EnvironmentObject var vm: CartViewModel

    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView {
                VStack(spacing: 14) {
                    
                    if vm.items.isEmpty && !vm.isLoading {
                        VStack(spacing: 8) {
                            Image(systemName: "cart")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.6))
                            Text("Your cart is empty")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 60)
                    }
                    
                    ForEach(vm.items) { item in
                        CartItemRow(
                            item: item,
                            onQtyChange: { newQty in
                                Task { await vm.updateQty(itemId: item._id, qty: newQty) }
                            },
                            onDelete: {
                                Task { await vm.remove(itemId: item._id) }
                            }
                        )
                    }

                    // ✅ spacing so last item not hidden behind bar
                    Spacer().frame(height: 90)
                }
                .padding()
            }
            .task { await vm.fetchCart() }

            // ✅ Sticky checkout bar
            CheckoutBar(total: vm.totalPrice) {
                // TODO: Navigate to checkout screen
                print("Checkout tapped. Total:", vm.totalPrice)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}


import SwiftUI

struct CheckoutBar: View {
    let total: Double
    var onCheckout: () -> Void = {}

    var body: some View {
        VStack(spacing: 10) {
            Divider()

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)

                    Text("$\(total, specifier: "%.0f")")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black.opacity(0.9))
                }

                Spacer()

                Button(action: onCheckout) {
                    Text("Checkout")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(width: 160)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(total <= 0)
                .opacity(total <= 0 ? 0.6 : 1)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .background(.ultraThinMaterial) // nice blur
    }
}
