import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// A Flutter demo screen for integrating Razorpay payment gateway.
///
/// This widget demonstrates how to use the `razorpay_flutter` package to
/// integrate Razorpay's checkout functionality into a Flutter application.
///
/// Features:
/// - Opens Razorpay's checkout screen with predefined payment options.
/// - Configures Razorpay with mock payment details such as amount, name, and contact info.
/// - Handles Razorpay payment success and failure events using callbacks.
///
/// Key Components:
/// - `Razorpay` instance: Initializes Razorpay and sets up event listeners for
///   handling payment outcomes.
/// - Payment Options: Includes mock data like amount, name, description, and prefill details
///   (contact number and email).
/// - Event Handlers:
///   - `_handlePaymentSuccess`: Invoked when a payment succeeds.
///   - `_handlePaymentError`: Invoked when a payment fails.
///
/// Dependencies:
/// - `razorpay_flutter`: Provides Razorpay's SDK for Flutter.
///
/// Usage:
/// - Replace mock options such as `amount`, `key`, and `prefill` details with real data in production.
/// - Ensure you set up your Razorpay account and use the correct API keys for live or test environments.
///
/// Notes:
/// - The `key` used in the `options` map is for demonstration purposes only and should
///   be replaced with your Razorpay API key.
/// - Make sure to validate payment responses on the server side for additional security.
///
/// Example Usage:
/// ```dart
/// RazorPayCheckoutPageDemo()
/// ```
class RazorPayCheckoutPageDemo extends StatefulWidget {
  const RazorPayCheckoutPageDemo({super.key});

  @override
  State<RazorPayCheckoutPageDemo> createState() =>
      _RazorPayCheckoutPageDemoState();
}

class _RazorPayCheckoutPageDemoState extends State<RazorPayCheckoutPageDemo> {
  String amountValue = "100";
  String orderIdValue = "1001";
  String mobileNumberValue = "9988998899";

  late Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            var options = {
              'key': 'rzp_test_qRGYYA5wZrpFvJ',
              'amount': 100,
              'name': 'Acme Corp.',
              'description': 'Fine T-Shirt',
              'prefill': {
                'contact': '8888888888',
                'email': 'test@razorpay.com',
              },
            };
            _razorpay.open(options);
          },
          child: const Text('Test Checkout'),
        ),
      ),
    );
  }
}
