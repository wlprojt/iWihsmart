//
//  WishmartTopBar.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct WishmartTopBar: View {
    var onSearchTap: () -> Void = {}

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(edges: .top)

            HStack(spacing: 10) {

                // ⭐ Star icon
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.yellow)

                // wishmart text
                Text("wishmart")
                    .font(.system(size: 30, weight: .bold))
                    .italic()
                    .foregroundColor(.white)

                Spacer()

                // 🔍 Search icon
                Button(action: onSearchTap) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 36)
        }
        .frame(height: topBarHeight)
    }

    // MARK: - Status bar + toolbar height
    private var topBarHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first

        let statusBarHeight = window?.safeAreaInsets.top ?? 10
        return statusBarHeight + 10
    }
}

#Preview {
    WishmartTopBar()
}
