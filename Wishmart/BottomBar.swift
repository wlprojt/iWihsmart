//
//  BottomBar.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case profile = "Profile"
    case cart = "Cart"
    case menu = "Menu"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .profile: return "person.fill"
        case .cart: return "cart.fill"
        case .menu: return "line.3.horizontal"
        }
    }
}

import SwiftUI

struct WishmartBottomBar: View {
    @Binding var selected: TabItem
    @EnvironmentObject var cartVM: CartViewModel   // ✅ shared cart

    var body: some View {
        VStack(spacing: 0) {
            Divider().opacity(0.2)

            HStack {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    BottomBarItem(
                        tab: tab,
                        isSelected: selected == tab,
                        cartCount: tab == .cart ? cartVM.items.count : 0
                    ) {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selected = tab
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 10)
            .padding(.bottom, 25)
            .background(Color.white)
        }
    }
}

private struct BottomBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let cartCount: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {

                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.gray.opacity(0.35))
                            .frame(width: 74, height: 40)
                    }

                    ZStack(alignment: .topTrailing) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.blue)

                        // ✅ Cart badge
                        if tab == .cart && cartCount > 0 {
                            Text("\(cartCount)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 12, y: -10)
                        }
                    }
                }

                Text(tab.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 2)
        }
        .buttonStyle(.plain)
    }
}
