//
//  HomeView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 20/02/26.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedProductId: String? = nil
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                    WishmartTopBar {
                        print("Search tapped")
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        HeroPromoCard()
                        ShopByCategoryCard()
                        VStack() {
                            PromoTilesRow()
                        }
                        .padding(.horizontal, 25)
                        .padding()
                        VStack() {
                            TodaysBestDealSection(
                                onSeeMore: { print("See more") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            PromoRowsSection { row in
                                print("Tapped:", row.title)
                            }
                        }
                        .padding(.horizontal, 25)
                        VStack() {
                            AudioVideoSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            HomeAppliancesSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            AirConditionerSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            Image("BannerOne")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.horizontal, 25)
                        VStack() {
                            KitchenAppliancesSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            RefrigeratorsSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            Image("BannerTwo")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.horizontal, 25)
                        VStack() {
                            PCsLaptopsSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            GadgetsSection(
                                onSeeMore: { print("See more audio & video") },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            BrandDealCard()
                        }
                        .padding(.horizontal, 25)
                        VStack() {
                            TopBrandsCard()
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 25)
                    }
                }
            .navigationDestination(item: $selectedProductId) { id in
                            ProductDetailView(productId: id)
                                .environmentObject(cartVM)
                                .navigationBarHidden(true) // because you have your own top bar
                        }
            }
    }
}

#Preview {
    HomeView()
}
