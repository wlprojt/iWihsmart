//
//  AllProductsScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import SwiftUI
struct AllProductsScreen: View {

    @StateObject private var vm = AllProductsViewModel()
    @State private var selectedProductId: String? = nil

    private let initialCategory: String?
    
    private let categories: [String] = [
            "", // All
            "Air Conditioner",
            "Audio & Video",
            "Gadgets",
            "Home Appliances",
            "Kitchen Appliances",
            "PCs & Laptop",
            "Refrigerator",
            "Smart Home"
        ]

    init(category: String? = nil) {
        self.initialCategory = category
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerBar
                filterBar
                content
            }
            .background(Color(.systemGroupedBackground))
            .task {
                if let initialCategory {
                    vm.category = initialCategory
                }
                await vm.refresh()
            }
            .navigationDestination(item: $selectedProductId) { id in
                ProductDetailView(productId: id)
                    .navigationBarHidden(true)
            }
        }
    }


    // MARK: - Header
    private var headerBar: some View {
        HStack {
            Text("All Products")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black.opacity(0.85))

            Spacer()

            Text("\(vm.total) items")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }

    // MARK: - Filters
    private var filterBar: some View {
        VStack(spacing: 12) {

            HStack(spacing: 12) {

                // Sort
                Menu {
                    ForEach(ProductSort.allCases) { s in
                        Button {
                            vm.sort = s
                            Task { await vm.applyFilters() }
                        } label: {
                            if vm.sort == s {
                                Label(s.title, systemImage: "checkmark")
                            } else {
                                Text(s.title)
                            }
                        }
                    }
                } label: {
                    filterPill(title: "Sort: \(vm.sort.title)", icon: "arrow.up.arrow.down")
                }

                // Category
                Menu {
                    ForEach(categories, id: \.self) { c in
                        Button {
                            vm.category = c
                            Task { await vm.applyFilters() }
                        } label: {
                            let title = c.isEmpty ? "All" : c
                            if vm.category == c {
                                Label(title, systemImage: "checkmark")
                            } else {
                                Text(title)
                            }
                        }
                    }
                } label: {
                    filterPill(title: vm.category.isEmpty ? "Category: All" : "Category: \(vm.category)", icon: "square.grid.2x2")
                }
            }

            // Price range
            HStack(spacing: 12) {
                priceField(title: "Min", value: $vm.minPrice)
                priceField(title: "Max", value: $vm.maxPrice)

                Button {
                    Task { await vm.applyFilters() }
                } label: {
                    Text("Apply")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }

    // MARK: - Content
    private var content: some View {
        Group {
            if vm.isLoading && vm.products.isEmpty {
                ProgressView("Loading...")
                    .padding(.top, 40)

            } else if let err = vm.errorMessage, vm.products.isEmpty {
                VStack(spacing: 10) {
                    Text(err).foregroundColor(.red)
                    Button("Retry") { Task { await vm.refresh() } }
                }
                .padding(.top, 40)

            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(vm.products) { p in
                            Button {
                                selectedProductId = p.id
                            } label: {
                                ProductGridCard(product: p)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                Task { await vm.loadNextPageIfNeeded(currentItem: p) }
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 10)

                    if vm.isLoading {
                        ProgressView().padding()
                    }
                }
            }
        }
    }

    // MARK: - Small UI helpers
    private func filterPill(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(1)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 6)
    }

    private func priceField(title: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)

            TextField(title, value: value, format: .number)
                .keyboardType(.numberPad)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 6)
        }
        .frame(maxWidth: .infinity)
    }
}
