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

    // ✅ Change if needed
    let baseURL = URL(string: "http://192.168.29.139:3000/")!

    func request<T: Decodable, Body: Encodable>(
        path: String,
        method: String,
        body: Body? = nil,
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {

        let url = baseURL.appendingPathComponent(path)
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
}

