//
//  HeroPromoCard.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct HeroPromoCard: View {
    var onShopNow: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Image
            Image("HeroImage") // ✅ add an image in Assets named: home_hero
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()

            // Bottom Card Content
            VStack(alignment: .leading, spacing: 14) {
                // Logo row (icon + text)
                HStack(spacing: 0) {
                    Image("HeroLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.black.opacity(0.8))
                }

                // Title
                Text("The best home entertainment\nsystem is here")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)

                // Description
                Text("Sit diam odio eget rhoncus volutpat est nibh velit posuere egestas.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)

                // CTA
                Button {
                    onShopNow()
                } label: {
                    HStack(spacing: 8) {
                        Text("Shop now")
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(Color.blue)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(20)
            .background(Color.white)
            .padding(.horizontal, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        HeroPromoCard()
    }
}
