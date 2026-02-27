//
//  CheckoutView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//

import SwiftUI

struct CheckoutScreen: View {

    @EnvironmentObject var cartVM: CartViewModel
    @StateObject private var vm = CheckoutVM()

    @State private var goSuccess = false

    // ✅ Put your Razorpay public key here
    private let razorpayKeyId = "<NEXT_PUBLIC_RAZORPAY_KEY_ID>"

    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView {
                VStack(spacing: 14) {

                    billingCard
                    addressCard
                    orderSummaryCard

                    if let err = vm.errorMessage {
                        Text(err)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                    }

                    Spacer().frame(height: 90)
                }
                .padding()
            }
            .task {
                await vm.loadUser()
                // ✅ DO NOT fetch cart here; we use cartVM.items
            }

            // ✅ Sticky Pay Bar
            payBar
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.large)

        // ✅ Payment Sheet
        .sheet(isPresented: $vm.showPaymentSheet) {
            RazorpayPaymentView(
                razorpayOrderId: vm.razorpayOrderId,
                amountUSD: cartVM.totalPrice,
                email: vm.email,
                phone: vm.phone,
                keyId: razorpayKeyId
            ) { paymentId, signature, orderId in
                Task {
                    let ok = await vm.verifyPayment(
                        razorpayOrderId: orderId,
                        razorpayPaymentId: paymentId,
                        razorpaySignature: signature
                    )
                    if ok {
                        await cartVM.fetchCart() // ✅ refresh cart after payment
                        goSuccess = true
                    }
                }
            } onDismiss: {
                vm.showPaymentSheet = false
            }
        }

        .navigationDestination(isPresented: $goSuccess) {
            OrderSuccessView()
        }
    }

    // MARK: - UI Cards

    private var billingCard: some View {
        CardContainer(title: "Billing Details") {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    LabeledTextField(title: "First name *", text: $vm.firstName)
                    LabeledTextField(title: "Last name *", text: $vm.lastName)
                }

                LabeledTextField(title: "Email *", text: $vm.email, keyboard: .emailAddress)
                LabeledTextField(title: "Phone *", text: $vm.phone, keyboard: .phonePad)
            }
        }
    }

    private var addressCard: some View {
        CardContainer(title: "Address") {
            VStack(spacing: 12) {
                LabeledTextField(title: "Street address *", text: $vm.address)
                LabeledTextField(title: "Apartment (optional)", text: $vm.apartment)

                HStack(spacing: 12) {
                    LabeledTextField(title: "Country *", text: $vm.country)
                    LabeledTextField(title: "State *", text: $vm.state)
                }

                HStack(spacing: 12) {
                    LabeledTextField(title: "City *", text: $vm.city)
                    LabeledTextField(title: "Postal Code *", text: $vm.postalCode, keyboard: .numbersAndPunctuation)
                }
            }
        }
    }

    private var orderSummaryCard: some View {
        CardContainer(title: "Order Summary") {
            if cartVM.items.isEmpty {
                Text("Your cart is empty")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 12) {
                    ForEach(cartVM.items) { item in
                        HStack(spacing: 12) {
                            RemoteImageOptional(urlString: item.image)
                                .frame(width: 54, height: 54)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                Text("Qty: \(item.qty)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(vm.money(vm.lineTotal(item)))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }

                    Divider().padding(.top, 4)

                    HStack {
                        Text("Total").fontWeight(.bold)
                        Spacer()
                        Text(vm.money(cartVM.totalPrice)).fontWeight(.bold)
                    }
                }
            }
        }
    }

    // MARK: - Sticky Pay Bar

    private var payBar: some View {
        VStack(spacing: 10) {
            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)

                    Text(vm.money(cartVM.totalPrice))
                        .font(.system(size: 22, weight: .bold))
                }

                Spacer()

                Button {
                    Task { await vm.startCheckout(using: cartVM.items, total: cartVM.totalPrice) }
                } label: {
                    Text(vm.isPlacingOrder ? "Please wait" : "Pay Now")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(width: 170)
                        .background(vm.canPay(items: cartVM.items, total: cartVM.totalPrice) ? Color.blue : Color.gray)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(!vm.canPay(items: cartVM.items, total: cartVM.totalPrice))
                .opacity(vm.canPay(items: cartVM.items, total: cartVM.totalPrice) ? 1 : 0.6)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .background(.ultraThinMaterial)
    }
}
