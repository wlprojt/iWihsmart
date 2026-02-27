//
//  OrderModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//

import Foundation

struct OrderCreateResponse: Decodable {
    let _id: String
}

struct RazorpayOrderResponse: Decodable {
    let id: String
    let amount: Int
    let currency: String
}

struct CreateOrderBody: Encodable {
    let email: String
    let billing: Billing
    let items: [OrderItem]
    let totalAmount: Double

    struct Billing: Encodable {
        let firstName: String
        let lastName: String
        let phone: String
        let address: String
        let apartment: String
        let country: String
        let state: String
        let city: String
        let postalCode: String
    }

    struct OrderItem: Encodable {
        let productId: String
        let title: String
        let price: Double
        let qty: Int
        let image: String?
    }
}

struct PaymentInitBody: Encodable {
    let amount: Double // ✅ send normal USD amount (your server multiplies *100)
}

struct VerifyPaymentRequest: Encodable {
    let orderId: String           // your DB order id
    let razorpayOrderId: String
    let razorpayPaymentId: String
    let razorpaySignature: String
}


