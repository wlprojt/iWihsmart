//
//  CartItemRow.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 23/02/26.
//

import SwiftUI

struct CartItemRow: View {

    let item: CartItem
    let onQtyChange: (Int) -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {

            // Image
            ZStack {
                Color.gray.opacity(0.1)
                if let url = imageURL {
                    AsyncImage(url: url) { img in
                        img.resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .clipped()

            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(2)

                Text("$\(item.sale_price ?? item.price, specifier: "%.0f")")
                    .font(.system(size: 16, weight: .bold))

                HStack(spacing: 12) {

                    Button {
                        onQtyChange(item.qty - 1)
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .disabled(item.qty <= 1)

                    Text("\(item.qty)")
                        .frame(width: 28)

                    Button {
                        onQtyChange(item.qty + 1)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(item.qty >= item.stock)
                }
                .font(.system(size: 16))
                .foregroundColor(.blue)
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }

    private var imageURL: URL? {
        guard let img = item.image else { return nil }
        if img.hasPrefix("http") {
            return URL(string: img)
        }
        let base = APIClient.shared.baseURL.absoluteString
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: base + "/" + img)
    }
}
