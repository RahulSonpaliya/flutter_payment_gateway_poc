import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// A custom Flutter payment screen for Stripe card payments.
///
/// This widget allows manual implementation of a card input form without using
/// Stripe's default `CardField`. Instead, it uses `dangerouslyUpdateCardDetails`
/// to send custom card details to Stripe, giving developers full control over the UI.
///
/// Features:
/// - Collects card details such as card number, expiration year/month, and CVC.
/// - Optionally allows saving card information with a checkbox.
/// - Sends card data securely to Stripe using `dangerouslyUpdateCardDetails`.
/// - Integrates with Stripe's API to create a PaymentMethod and facilitate payments.
///
/// **Important Notes:**
/// - Using `dangerouslyUpdateCardDetails` may potentially violate PCI compliance.
///   Developers must ensure PCI compliance to avoid security issues.
///   Reference: https://stripe.com/docs/security/guide#validating-pci-compliance.
/// - Replace mocked billing details with real user data in production.
///
/// Dependencies:
/// - flutter_stripe: For Stripe's SDK and payment processing.
///
/// Usage:
/// ```dart
/// CustomCardPaymentScreen()
/// ```
///
/// This is ideal for scenarios where Stripe's default card form doesn't meet UI/UX needs.
class CustomCardPaymentScreen extends StatefulWidget {
  const CustomCardPaymentScreen({super.key});

  @override
  _CustomCardPaymentScreenState createState() =>
      _CustomCardPaymentScreenState();
}

class _CustomCardPaymentScreenState extends State<CustomCardPaymentScreen> {
  CardDetails _card = CardDetails();
  bool? _saveCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                    'If you don\'t want to or can\'t rely on the CardField you'
                    ' can use the dangerouslyUpdateCardDetails in combination with '
                    'your own card field implementation. \n\n'
                    'Please beware that this will potentially break PCI compliance: '
                    'https://stripe.com/docs/security/guide#validating-pci-compliance')),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Number'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(number: number);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Exp. Year'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(
                              expirationYear: int.tryParse(number));
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Exp. Month'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(
                              expirationMonth: int.tryParse(number));
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'CVC'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(cvc: number);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              value: _saveCard,
              onChanged: (value) {
                setState(() {
                  _saveCard = value;
                });
              },
              title: const Text('Save card during payment'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
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
    );
  }

  Future<void> _handlePayPress() async {
    await Stripe.instance.dangerouslyUpdateCardDetails(_card);

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
}
