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
    @State private var showSearch = false
    @State private var showAllProducts = false
    @State private var allProductsCategory: String? = nil
    @State private var showSaleScreen = false
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WishmartTopBar {
                                    showSearch = true
                                }
                    .padding(.horizontal, 20)
                    
                    ScrollView {
                        HeroPromoCard(
                            onShopNow: {
                                allProductsCategory = "Audio & Video"
                                        showAllProducts = true
                            }
                        )
                        ShopByCategoryCard { cat in
                            allProductsCategory = (cat.title == "All Products") ? "" : cat.title
                            showAllProducts = true
                        }
                        VStack() {
                            PromoTilesRow { tile in
                                if tile.title.contains("30%") {
                                    allProductsCategory = "Gadgets"
                                    showAllProducts = true
                                }
                                if tile.title.contains("case") {
                                    allProductsCategory = "Gadgets"
                                    showAllProducts = true
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding()
                        VStack() {
                            TodaysBestDealSection(
                                onSeeMore: { showSaleScreen = true },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            PromoRowsSection { row in
                                selectedCategory = row.category
                            }
                        }
                        .padding(.horizontal, 25)
                        VStack() {
                            AudioVideoSection(
                                onSeeMore: {
                                    allProductsCategory = "Audio & Video"
                                            showAllProducts = true
                                },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            HomeAppliancesSection(
                                onSeeMore: {
                                    allProductsCategory = "Home Appliances"
                                            showAllProducts = true
                                },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            AirConditionerSection(
                                onSeeMore: {
                                    allProductsCategory = "Air Conditioner"
                                            showAllProducts = true
                                },
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
                                onSeeMore: {
                                    allProductsCategory = "Kitchen Appliances"
                                            showAllProducts = true
                                },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            RefrigeratorsSection(
                                onSeeMore: {
                                    allProductsCategory = "Refrigerator"
                                            showAllProducts = true
                                },
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
                                onSeeMore: {
                                    allProductsCategory = "PCs & Laptop"
                                            showAllProducts = true
                                },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            GadgetsSection(
                                onSeeMore: {
                                    allProductsCategory = "Gadgets"
                                            showAllProducts = true
                                },
                                onProductTap: { p in selectedProductId = p.id }
                            )
                        }
                        .padding()
                        VStack() {
                            BrandDealCard(categoryToOpen: "Home Appliances") { cat in
                                selectedCategory = cat
                            }
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
            .navigationDestination(isPresented: $showSearch) {
                            SearchScreen()
                                .navigationBarHidden(true)
                        }
            .navigationDestination(isPresented: $showAllProducts) {
                AllProductsScreen(category: allProductsCategory ?? "")
                    .navigationBarHidden(true)
            }
            .navigationDestination(isPresented: $showSaleScreen) {
                SaleProductsScreen()
                    .navigationBarHidden(true)
            }
            .navigationDestination(item: $selectedCategory) { cat in
                AllProductsScreen(category: cat)
                    .navigationBarHidden(true)
            }
            }
    }
}

#Preview {
    HomeView()
}
