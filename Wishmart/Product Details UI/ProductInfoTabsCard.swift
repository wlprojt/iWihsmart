//
//  ProductInfoTabsCard.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import SwiftUI

// MARK: - Description / Reviews Section (like screenshot)
struct ProductInfoTabsCard: View {

    var descriptionText: String
    var reviewsCount: Int = 0

    // If you want to show reviews list later
    var reviewsContent: AnyView = AnyView(
        Text("No reviews yet")
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    )

    @State private var tab: Tab = .description

    enum Tab { case description, reviews }

    var body: some View {
        VStack(spacing: 14) {

            // ✅ "Guaranteed Safe Checkout" + payment icons row
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    line
                    Text("Guaranteed Safe Checkout")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                    line
                }

                HStack(spacing: 10) {
                    Image("IPayment")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
            }
            .padding(.horizontal, 16)

            // ✅ Tabs header
            HStack(spacing: 0) {
                TabButton(
                    title: "Description",
                    isSelected: tab == .description
                ) { tab = .description }

                TabButton(
                    title: "Reviews (\(reviewsCount))",
                    isSelected: tab == .reviews
                ) { tab = .reviews }
            }
            .background(Color.white)

            // ✅ Content card
            VStack(alignment: .leading, spacing: 12) {
                if tab == .description {
                    Text("More about the product")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))

                    Text(descriptionText)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.gray)
                        .lineSpacing(6)
                } else {
                    reviewsContent
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var line: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.35))
            .frame(height: 1)
            .frame(width: 50)
    }
}

// MARK: - Tab Button
private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)

                Rectangle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(height: 3)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Simple Payment Badge (placeholder)
private struct PaymentBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.black.opacity(0.85))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
    }
}

#Preview {
    ScrollView {
        ProductInfoTabsCard(
            descriptionText: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sollicitudin consequat justo in cursus. Proin non velit quam. Etiam diam turpis, elementum in gravida maximus, efficitur quis nulla.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sit amet interdum lorem. Mauris elementum justo id ante ornare consectetur.
"""
        )
        .padding(.top, 20)
    }
    .background(Color(.systemGroupedBackground))
}
