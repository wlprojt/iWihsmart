//
//  SaleProductsScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import SwiftUI

struct SaleProductsScreen: View {
    @StateObject private var vm = SaleProductsViewModel()
    @State private var selectedProductId: String? = nil

    var body: some View {
        VStack(spacing: 0) {

            // simple header
            HStack {
                Text("Sale Products")
                    .font(.system(size: 28, weight: .bold))
                Spacer()
                Text("\(vm.products.count) items")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            Group {
                if vm.isLoading {
                    ProgressView("Loading...").padding(.top, 40)
                } else if let err = vm.errorMessage {
                    VStack(spacing: 10) {
                        Text(err).foregroundColor(.red)
                        Button("Retry") { Task { await vm.fetch() } }
                    }
                    .padding(.top, 40)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(vm.products) { p in
                                Button { selectedProductId = p.id } label: {
                                    ProductGridCard(product: p)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .task {
            if vm.products.isEmpty { await vm.fetch() }
        }
        .navigationDestination(item: $selectedProductId) { id in
            ProductDetailView(productId: id)
                .navigationBarHidden(true)
        }
    }
}
