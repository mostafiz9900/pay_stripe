import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay_stripe/ui/home_view.dart';

void main() async {
  String stripePublishableKey =
      "pk_test_51LxVfNCxNq7AOYEIPhS6CGwOwqNYxEHg079VEFoRnv6AJCkCV1fMIuAwIkVW5R2MkderZGFZLUj6gzf5kCdotfUk00AB1Tlbb1";
  String stripeSecretKey =
      "sk_test_51LxVfNCxNq7AOYEItu9OLFHT4FCifRT2MkLjAarUPNsTwzD9x0Oh4rWWZze9JlBBjeogGlq2WGkAoL1Pq0POMCKd006jtBJWPG";
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}
