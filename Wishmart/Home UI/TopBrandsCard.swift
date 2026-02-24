//
//  TopBrandsCard.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct BrandLogoModel: Identifiable {
    let id = UUID()
    let imageName: String   // Asset name
}

struct TopBrandsCard: View {

    // ✅ Add these images in Assets.xcassets
    let brands: [BrandLogoModel] = [
        .init(imageName: "LogoOne"),
        .init(imageName: "LogoTwo"),
        .init(imageName: "LogoThree"),
        .init(imageName: "LogoFour"),
        .init(imageName: "LogoFive"),
        .init(imageName: "LogoSix")
    ]

    var onBrandTap: (BrandLogoModel) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Top brands")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black.opacity(0.85))
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 26) {
                    ForEach(brands) { b in
                        Button {
                            onBrandTap(b)
                        } label: {
                            BrandLogoCell(imageName: b.imageName)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(22)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.black.opacity(0.16), radius: 14, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}

private struct BrandLogoCell: View {
    let imageName: String

    var body: some View {
        ZStack {
            // keeps spacing similar to screenshot
            Color.clear

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .accessibilityLabel(Text("Brand"))
        }
        .frame(height: 70)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        TopBrandsCard()
            .padding(.top, 16)
    }
}
