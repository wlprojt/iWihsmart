//
//  APIClient.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 19/02/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case http(Int, String?)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .http(let code, let body):
            return "HTTP \(code): \(body ?? "")"
        }
    }
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    let baseURL = URL(string: "http://192.168.29.138:3000/")!

    // ✅ Always build URL safely (supports query strings)
    private func makeURL(path: String) throws -> URL {
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path

        // Split "api/products?category=Air conditioner"
        let parts = trimmed.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: false)
        let purePath = String(parts.first ?? "")

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidResponse
        }

        // Join base path + endpoint path
        let basePath = components.path.hasSuffix("/") ? String(components.path.dropLast()) : components.path
        components.path = basePath + "/" + purePath

        // If query exists, set it (URLComponents will encode it correctly)
        if parts.count == 2 {
            let rawQuery = String(parts[1])
            components.query = rawQuery
        }

        guard let url = components.url else { throw APIError.invalidResponse }
        return url
    }

    func request<T: Decodable, Body: Encodable>(
        path: String,
        method: String,
        body: Body? = nil,
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {

        let url = try makeURL(path: path)   // ✅ FIXED
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth, let token = KeychainStore.shared.getToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            req.httpBody = try JSONEncoder().encode(body)
        }

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }

        if !(200..<300).contains(http.statusCode) {
            let msg = String(data: data, encoding: .utf8)
            throw APIError.http(http.statusCode, msg)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    func request<T: Decodable>(
        path: String,
        method: String,
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {
        try await request(path: path, method: method, body: Optional<Int>.none, requiresAuth: requiresAuth, responseType: responseType)
    }

    // ✅ Keep your query helper too (optional)
    func request<T: Decodable>(
        path: String,
        method: String,
        query: [String: String],
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidResponse
        }

        let basePath = components.path.hasSuffix("/") ? String(components.path.dropLast()) : components.path
        let cleanPath = path.hasPrefix("/") ? path : "/\(path)"
        components.path = basePath + cleanPath

        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else { throw APIError.invalidResponse }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth, let token = KeychainStore.shared.getToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }

        if !(200..<300).contains(http.statusCode) {
            let msg = String(data: data, encoding: .utf8)
            throw APIError.http(http.statusCode, msg)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
