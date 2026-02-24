//
//  Untitled 2.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct CategoryModel: Identifiable {
    let id = UUID()
    let title: String
    let productCount: Int
    let imageName: String // Asset name
}

struct ShopByCategoryCard: View {

    // Same categories as your Android list (8 items)
    let categories: [CategoryModel] = [
        .init(title: "Air Conditioner", productCount: 4, imageName: "AC"),
        .init(title: "Audio & Video", productCount: 5, imageName: "TV"),
        .init(title: "Gadgets", productCount: 6, imageName: "Phone"),
        .init(title: "Home Appliances", productCount: 5, imageName: "Washing"),
        .init(title: "Kitchen Appliances", productCount: 6, imageName: "Oven"),
        .init(title: "PCs & Laptop", productCount: 4, imageName: "Laptop"),
        .init(title: "Refrigerator", productCount: 4, imageName: "Fridger"),
        .init(title: "Smart Home", productCount: 5, imageName: "Smart")
    ]

    var onTap: ((CategoryModel) -> Void)? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("Shop by Category")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.85))
                .padding(.top, 10)
                .padding(.bottom, 10)

            Spacer().frame(height: 24)

            // Like heightIn(max = 400.dp)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categories) { category in
                        Button {
                            onTap?(category)
                        } label: {
                            CategoryItemView(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 6)
            }
            .frame(maxHeight: 400) // ✅ same idea as your Compose max height

        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
        .padding(.horizontal, 40)
        .padding(.top, 8)
    }
}

private struct CategoryItemView: View {
    let category: CategoryModel

    var body: some View {
        VStack(spacing: 4) {
            Image(category.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text(category.title.uppercased())
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.black.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, -30)

            Text("\(category.productCount) Products")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.top, -12)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        ShopByCategoryCard()
    }
}
