//
//  BrandDealCard.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct BrandDealCard: View {

    // ✅ Replace with your asset name OR remote URL usage
    var imageName: String = "brand_deal_washer"

    var tagText: String = "BRAND’S DEAL"
    var titleText: String = "Save up to $200 on select\nSamsung washing machine"
    var descText: String = "Tortor purus et quis aenean tempus tellus fames."
    var ctaText: String = "Shop now"

    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 14) {

                // Image
                Image("WImage")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 230)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .clipped()

                // Text content
                VStack(alignment: .leading, spacing: 10) {

                    Text(tagText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .tracking(1.2)

                    Text(titleText)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                    Text(descText)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(ctaText)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 6)
            }
            .padding(18)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.black.opacity(0.16), radius: 14, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        VStack {
            BrandDealCard()
        }
        .padding(.top, 12)
    }
}
