import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../widgets/loading_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // initPaymentSheet();
                },
                child: const Text('click'),
              ),
              PaymentSheetScreen()
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentSheetScreen extends StatefulWidget {
  @override
  _PaymentSheetScreenState createState() => _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreen> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stepper(
          controlsBuilder: (context, details) {
            return const Text('data');
          },
          currentStep: step,
          steps: [
            Step(
              title: const Text('Init payment'),
              content: LoadingButton(
                onPressed: initPaymentSheet,
                text: 'Init payment sheet',
              ),
            ),
            Step(
              title: const Text('Confirm payment'),
              content: LoadingButton(
                onPressed: confirmPayment,
                text: 'Pay now',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _createTestPaymentSheet() async {
    final url = Uri.parse('$kApiUrl/payment-sheet');
    Map<String, dynamic> bodyData = {
      'amount': "50",
      'currency': "USD",
      'payment_method_types[]': 'card',
      // 'receipt_email': "mostafiz9900@gmail.com",
      // 'automatic_payment_methods': {
      //   'enabled': true,
      // },
      // 'customer': customerId
    };
    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: json.encode({
    //     'a': 'a',
    //   }),
    // );
    var response = await http.post(Uri.parse('${kApiUrl}v1/payment_intents'),
        body: bodyData,
        headers: {
          'Authorization':
              'Bearer sk_test_51LxVfNCxNq7AOYEItu9OLFHT4FCifRT2MkLjAarUPNsTwzD9x0Oh4rWWZze9JlBBjeogGlq2WGkAoL1Pq0POMCKd006jtBJWPG',
          'Content-Type': 'application/x-www-form-urlencoded'
          // 'Content-Type': 'application/json',
        });
//       print('Create Intent reponse ===> ${response.body.toString()}');
    final body = json.decode(response.body);
    if (body['error'] != null) {
      throw Exception(body['error']);
    }
    return body;
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet();

      // create some billingdetails
      final billingDetails = const BillingDetails(
        name: 'Flutter Stripe',
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
      print('sfsfsfslf ${data.toString()}');

      // 2. initialize the payment sheet

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['client_secret'],
          merchantDisplayName: 'Mostafizur',
          // Customer params
          customerId: data['customer'],
          customerEphemeralKeySecret: data['ephemeralKey'],

          // Extra params
          // primaryButtonLabel: 'Pay now',
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: 'DE',
          // ),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'DE',
          //   testEnv: true,
          // ),
          style: ThemeMode.dark,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.lightBlue,
              primary: Colors.blue,
              componentBorder: Colors.red,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: Colors.red),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color.fromARGB(255, 231, 235, 30),
                  text: Color.fromARGB(255, 235, 92, 30),
                  border: Color.fromARGB(255, 235, 92, 30),
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      setState(() {
        step = 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      print('confirm payment =================================');
      await Stripe.instance.presentPaymentSheet();
      // await Stripe.instance.confirmPaymentSheetPayment();
      print('confirm payment =======================4444==========');

      setState(() {
        step = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on Exception catch (e) {
      print(' erere reoreor0ejreojroewj rtoijwe $e');

      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }
}
