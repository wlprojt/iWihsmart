//
//  RazorpayPaymentView.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//

import SwiftUI
import WebKit

struct RazorpayPaymentView: UIViewRepresentable {

    let razorpayOrderId: String
    let amountUSD: Double
    let email: String
    let phone: String
    let keyId: String

    let onSuccess: (_ paymentId: String, _ signature: String, _ orderId: String) -> Void
    let onDismiss: () -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let controller = WKUserContentController()
        controller.add(context.coordinator, name: "razorpay")

        let config = WKWebViewConfiguration()
        config.userContentController = controller

        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler {
        let parent: RazorpayPaymentView
        init(_ parent: RazorpayPaymentView) { self.parent = parent }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "razorpay" else { return }

            if let dict = message.body as? [String: Any],
               let payId = dict["razorpay_payment_id"] as? String,
               let orderId = dict["razorpay_order_id"] as? String,
               let sig = dict["razorpay_signature"] as? String {
                parent.onSuccess(payId, sig, orderId)
            } else {
                parent.onDismiss()
            }
        }
    }

    private var html: String {
        let amountSubunits = Int((amountUSD * 100).rounded())

        return """
        <!doctype html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
          </head>
          <body>
            <script>
              var options = {
                key: "\(keyId)",
                amount: \(amountSubunits),
                currency: "USD",
                name: "Your Store",
                description: "Checkout Payment",
                order_id: "\(razorpayOrderId)",
                prefill: { email: "\(email)", contact: "\(phone)" },
                handler: function (response) {
                  window.webkit.messageHandlers.razorpay.postMessage(response);
                },
                modal: {
                  ondismiss: function() {
                    window.webkit.messageHandlers.razorpay.postMessage({dismissed:true});
                  }
                }
              };
              var rzp = new Razorpay(options);
              rzp.open();
            </script>
          </body>
        </html>
        """
    }
}
