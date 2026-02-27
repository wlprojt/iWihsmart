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
            Color.blue.ignoresSafeArea(edges: .top)

            HStack(spacing: 10) {

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                Text("wishmart")
                    .font(.system(size: 30, weight: .bold))
                    .italic()
                    .foregroundColor(.white)

                Spacer()

                Button(action: onSearchTap) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)     // ✅ pushes below notch
            .padding(.bottom, 10)          // ✅ gives nice height
        }
        .frame(height: safeTop)       // ✅ perfect topbar height
    }

    private var safeTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
    }
}
