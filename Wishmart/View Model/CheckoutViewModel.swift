//
//  CheckoutViewModel.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//

import Foundation
internal import Combine

@MainActor
final class CheckoutVM: ObservableObject {

    private let auth = AuthService()
    private let orderService = OrderService()

    // Billing
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""

    // Address
    @Published var address = ""
    @Published var apartment = ""
    @Published var country = "United States"
    @Published var state = ""
    @Published var city = ""
    @Published var postalCode = ""

    // UI
    @Published var isPlacingOrder = false
    @Published var errorMessage: String?

    // Payment
    @Published var showPaymentSheet = false
    @Published var razorpayOrderId = ""
    private var dbOrderId = ""

    func loadUser() async {
        errorMessage = nil
        do {
            let me = try await auth.me()
            email = me.email
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func canPay(items: [CartItem], total: Double) -> Bool {
        !firstName.trimmed.isEmpty &&
        !lastName.trimmed.isEmpty &&
        !email.trimmed.isEmpty &&
        !phone.trimmed.isEmpty &&
        !address.trimmed.isEmpty &&
        !country.trimmed.isEmpty &&
        !state.trimmed.isEmpty &&
        !city.trimmed.isEmpty &&
        !postalCode.trimmed.isEmpty &&
        !items.isEmpty &&
        total > 0 &&
        !isPlacingOrder
    }

    func lineTotal(_ item: CartItem) -> Double {
        let unit = item.sale_price ?? item.price
        return unit * Double(item.qty)
    }

    func money(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: NSNumber(value: value)) ?? "$\(value)"
    }

    func startCheckout(using items: [CartItem], total: Double) async {
        guard canPay(items: items, total: total) else { return }

        errorMessage = nil
        isPlacingOrder = true
        defer { isPlacingOrder = false }

        do {
            // 1) Create DB order (pending)
            let createBody = CreateOrderBody(
                email: email,
                billing: .init(
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                    address: address,
                    apartment: apartment,
                    country: country,
                    state: state,
                    city: city,
                    postalCode: postalCode
                ),
                items: items.map {
                    .init(
                        productId: $0.productId,
                        title: $0.title,
                        price: ($0.sale_price ?? $0.price),
                        qty: $0.qty,
                        image: $0.image
                    )
                },
                totalAmount: total
            )

            let created = try await orderService.createOrder(body: createBody)
            dbOrderId = created._id

            // 2) Create Razorpay order (send USD amount; backend multiplies *100)
            let rp = try await orderService.createRazorpayOrder(amountUSD: total)
            razorpayOrderId = rp.id

            // 3) Open payment
            showPaymentSheet = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func verifyPayment(
        razorpayOrderId: String,
        razorpayPaymentId: String,
        razorpaySignature: String
    ) async -> Bool {
        do {
            _ = try await orderService.verifyPayment(
                body: VerifyPaymentRequest(
                    orderId: dbOrderId,
                    razorpayOrderId: razorpayOrderId,
                    razorpayPaymentId: razorpayPaymentId,
                    razorpaySignature: razorpaySignature
                )
            )
            showPaymentSheet = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            showPaymentSheet = false
            return false
        }
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
