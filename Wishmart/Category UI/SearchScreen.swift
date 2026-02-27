//
//  SearchScreen.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import SwiftUI

import SwiftUI

struct SearchScreen: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SearchViewModel()
    @State private var selectedProductId: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Top bar (your style)
                ZStack {
                    Color.blue.ignoresSafeArea(edges: .top)

                    HStack(spacing: 12) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)

                        TextField("Search products…", text: $vm.query)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.search)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(Color.white.opacity(0.18))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .tint(.white)

                        if !vm.query.isEmpty {
                            Button("Clear") { vm.clear() }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: topBarHeight)

                // Content
                Group {
                    if vm.isLoading {
                        ProgressView().padding(.top, 20)
                    }

                    if let err = vm.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    if vm.suggestions.isEmpty && vm.query.count >= 2 && !vm.isLoading {
                        Text("No results")
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(vm.suggestions) { s in
                                    Button {
                                        selectedProductId = s.id
                                    } label: {
                                        SuggestionRow(suggestion: s)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            }
            .navigationDestination(item: $selectedProductId) { id in
                ProductDetailView(productId: id)
                    .navigationBarHidden(true)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var topBarHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first

        let statusBarHeight = window?.safeAreaInsets.top ?? 10
        return statusBarHeight + 52
    }
}

private struct SuggestionRow: View {
    let suggestion: ProductSuggestion

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.gray.opacity(0.12)

                if let url = imageURL {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(8)
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            .frame(width: 54, height: 54)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(suggestion.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black.opacity(0.85))
                .lineLimit(2)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 6)
    }

    private var imageURL: URL? {
        guard let first = suggestion.images?.first else { return nil }

        if first.hasPrefix("http://") || first.hasPrefix("https://") {
            return URL(string: first)
        }

        let base = APIClient.shared.baseURL.absoluteString
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let path = first.hasPrefix("/") ? first : "/\(first)"
        return URL(string: base + path)
    }
}
