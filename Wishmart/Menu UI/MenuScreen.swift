//
//  MenuScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import SwiftUI

struct MenuCategory: Identifiable {
    let id = UUID()
    let title: String
    let apiValue: String?   // nil = All
}

struct MenuScreen: View {

    private let categories: [MenuCategory] = [
        .init(title: "All Products", apiValue: nil),
        .init(title: "Air Conditioner", apiValue: "Air Conditioner"),
        .init(title: "Audio & Video", apiValue: "Audio & Video"),
        .init(title: "Gadgets", apiValue: "Gadgets"),
        .init(title: "Home Appliances", apiValue: "Home Appliances"),
        .init(title: "Kitchen Appliances", apiValue: "Kitchen Appliances"),
        .init(title: "PCs & Laptop", apiValue: "PCs & Laptop"),
        .init(title: "Refrigerator", apiValue: "Refrigerator"),
        .init(title: "Smart Home", apiValue: "Smart Home")
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {

                Text("Menu")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black.opacity(0.85))
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 10)

                VStack(spacing: 0) {
                    ForEach(categories) { category in
                        NavigationLink {
                            AllProductsScreen(category: category.apiValue)
                                .toolbar(.hidden, for: .navigationBar)
                        } label: {
                            HStack {
                                Text(category.title)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black.opacity(0.8))
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.plain)

                        Divider().opacity(0.15)
                            .padding(.leading, 20)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
                .padding(.horizontal, 16)
                .padding(.top, 10)

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
