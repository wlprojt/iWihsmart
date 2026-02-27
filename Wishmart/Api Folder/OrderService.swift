//
//  OrderService.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//

import Foundation


final class OrderService {
    func createOrder(body: CreateOrderBody) async throws -> OrderCreateResponse {
        try await APIClient.shared.request(
            path: "api/orders/create",
            method: "POST",
            body: body,
            requiresAuth: true,
            responseType: OrderCreateResponse.self
        )
    }

    func createRazorpayOrder(amountUSD: Double) async throws -> RazorpayOrderResponse {
        try await APIClient.shared.request(
            path: "api/payment",
            method: "POST",
            body: PaymentInitBody(amount: amountUSD),
            requiresAuth: false,
            responseType: RazorpayOrderResponse.self
        )
    }

    func verifyPayment(body: VerifyPaymentRequest) async throws -> ApiResponse {
        try await APIClient.shared.request(
            path: "api/orders/verify",
            method: "POST",
            body: body,
            requiresAuth: false,
            responseType: ApiResponse.self
        )
    }
}
