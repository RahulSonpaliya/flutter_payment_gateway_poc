import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// A Flutter payment screen widget for handling Stripe card payments.
///
/// This widget integrates with the `flutter_stripe` package to provide
/// a card payment form and handle payment flow using Stripe's API.
///
/// Features:
/// - Displays a card input form using `CardFormField`.
/// - Collects billing details including email, phone, and address.
/// - Creates a Stripe PaymentMethod using the entered card details.
/// - Provides a "Pay" button to trigger the payment process.
/// - Shows error messages via a SnackBar if the payment process fails.
///
/// Dependencies:
/// - flutter_stripe: Handles Stripe's SDK and APIs for payment processing.
///
/// Usage:
/// ```dart
/// StripeCardWidgetPaymentScreen()
/// ```
///
/// Notes:
/// - Replace mocked billing details with real user data in production.
/// - The API call to create PaymentIntent is mocked and needs to be implemented.
class StripeCardWidgetPaymentScreen extends StatefulWidget {
  const StripeCardWidgetPaymentScreen({super.key});

  @override
  _StripeCardWidgetPaymentScreenState createState() =>
      _StripeCardWidgetPaymentScreenState();
}

class _StripeCardWidgetPaymentScreenState
    extends State<StripeCardWidgetPaymentScreen> {
  final controller = CardFormEditController();

  Future<void> _handlePayPress() async {
    if (!controller.details.complete) {
      return;
    }

    try {
      // 1. Gather customer billing information (ex. email)
      const billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));

      debugPrint('paymentMethod.id ${paymentMethod.id}');

      // 3. call API to create PaymentIntent
      // final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
      //   useStripeSdk: true,
      //   paymentMethodId: paymentMethod.id,
      //   currency: 'usd', // mocked data
      //   items: ['id-1'],
      // );

      // 4. handle api response i.e. paymentIntentResult
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardFormField(
                controller: controller,
                countryCode: 'US',
                style: CardFormStyle(
                  borderColor: Colors.blueGrey,
                  textColor: Colors.black,
                  placeholderColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _handlePayPress,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 16.0),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Pay',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
