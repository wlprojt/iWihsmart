//
//  SearchViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 24/02/26.
//

import Foundation
internal import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var suggestions: [ProductSuggestion] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var bag = Set<AnyCancellable>()

    init() {
        // debounce typing
        $query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                Task { await self.fetchSuggestions(q: text) }
            }
            .store(in: &bag)
    }

    func fetchSuggestions(q: String) async {
        if q.count < 2 {
            suggestions = []
            errorMessage = nil
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let res: [ProductSuggestion] = try await APIClient.shared.request(
                path: "api/products/suggestions",
                method: "GET",
                query: ["q": q],
                responseType: [ProductSuggestion].self
            )
            suggestions = res
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            suggestions = []
        }
    }

    func clear() {
        query = ""
        suggestions = []
        errorMessage = nil
    }
}
