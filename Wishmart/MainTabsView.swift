//
//  MainTabsView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct MainTabsView: View {
    @State private var selected: TabItem = .home
    @StateObject private var cartVM = CartViewModel()   // ✅ shared

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selected {
                case .home:
                    HomeView()
                        .environmentObject(cartVM)

                case .profile:
                    ProfileView()

                case .cart:
                    CartScreen()
                        .environmentObject(cartVM)

                case .menu:
                    MenuScreen()
                        .environmentObject(cartVM)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            WishmartBottomBar(selected: $selected)
                .environmentObject(cartVM)
                .padding(.horizontal)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainTabsView()
}
