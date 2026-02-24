//
//  PromoTiles.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 21/02/26.
//

import SwiftUI

struct PromoTileModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String   // Asset name
    let isTitleBig: Bool
}

struct PromoTilesRow: View {

    let tiles: [PromoTileModel] = [
        .init(
            title: "The only case\nyou need.",
            subtitle: "Shop Now",
            imageName: "SBGTwo",   // ✅ add in Assets
            isTitleBig: true
        ),
        .init(
            title: "Get 30% OFF",
            subtitle: "Shop Now",
            imageName: "SBGOne", // ✅ add in Assets
            isTitleBig: false
        )
    ]

    var onTap: ((PromoTileModel) -> Void)? = nil

    var body: some View {
        HStack(spacing: 14) {
            ForEach(tiles) { tile in
                Button {
                    onTap?(tile)
                } label: {
                    PromoTile(tile: tile)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(alignment: .center)
    }
}

private struct PromoTile: View {
    let tile: PromoTileModel

    var body: some View {
        ZStack {
            // Background image
            Image(tile.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)

            // Centered text
            VStack(spacing: 10) {
                Text(tile.title)
                    .font(.system(size: tile.isTitleBig ? 26 : 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 70, height: 2)

                Text(tile.subtitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        VStack(spacing: 20) {
            PromoTilesRow()
        }
    }
}
