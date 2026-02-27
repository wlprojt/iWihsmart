//
//  BrandDealCard.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 22/02/26.
//

import SwiftUI

struct BrandDealCard: View {

    // If you pass remoteImageURL, it will be used. Otherwise assetName will be used.
    var assetName: String = "WImage"
    var remoteImageURL: String? = nil

    var tagText: String = "BRAND’S DEAL"
    var titleText: String = "Save up to $200 on select\nSamsung washing machine"
    var descText: String = "Tortor purus et quis aenean tempus tellus fames."
    var ctaText: String = "Shop now"

    // ✅ what to open
    var categoryToOpen: String = "Home Appliances"
    var onTap: (String) -> Void = { _ in }

    var body: some View {
        Button {
            onTap(categoryToOpen)
        } label: {
            VStack(alignment: .leading, spacing: 14) {

                // Image
                imageView
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
                        .font(.system(size: 18))
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
            .background(Color(.white))
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

    @ViewBuilder
    private var imageView: some View {
        if let remoteImageURL,
           let url = URL(string: remoteImageURL) {
            ZStack {
                Color.gray.opacity(0.08)
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            }
        } else {
            Image(assetName)
                .resizable()
                .scaledToFill()
        }
    }
}
