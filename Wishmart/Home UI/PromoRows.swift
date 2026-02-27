//
//  PromoRows.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 21/02/26.
//

import SwiftUI

struct PromoRowModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let cta: String
    let imageName: String
    let background: Color
    let category: String
}

struct PromoRowsSection: View {

    let rows: [PromoRowModel] = [
        .init(
            title: "Wireless\nheadphones",
            subtitle: "Starting at $49",
            cta: "Shop now",
            imageName: "HeadPhone",
            background: Color(red: 0.93, green: 0.95, blue: 0.96),
            category: "Audio & Video"
        ),
        .init(
            title: "Grooming",
            subtitle: "Starting at $49",
            cta: "Shop now",
            imageName: "Treamer",
            background: Color(red: 0.93, green: 0.95, blue: 0.96),
            category: "Gadgets"
        ),
        .init(
            title: "Video games",
            subtitle: "Starting at $49",
            cta: "Shop now",
            imageName: "Games",
            background: Color(red: 0.96, green: 0.90, blue: 0.78),
            category: "Gadgets"
        )
    ]

    var onTap: ((PromoRowModel) -> Void)? = nil

    var body: some View {
        VStack(spacing: 18) {
            ForEach(rows) { row in
                Button { onTap?(row) } label: {
                    PromoRowCard(row: row)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct PromoRowCard: View {
    let row: PromoRowModel

    var body: some View {
        HStack(spacing: 14) {

            VStack(alignment: .leading, spacing: 8) {
                Text(row.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black.opacity(0.80))
                    .lineLimit(2)

                Text(row.subtitle)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.gray)

                Text(row.cta)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.top, 2)
            }

            Spacer()

            Image(row.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .padding(.trailing, 6)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(row.background)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        PromoRowsSection()
            .padding(.top, 12)
    }
}
