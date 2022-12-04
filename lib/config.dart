import 'package:flutter/foundation.dart';

// If you are using a real device to test the integration replace this url
// with the endpoint of your test server (it usually should be the IP of your computer)
final kApiUrl = defaultTargetPlatform == TargetPlatform.android
    ? 'https://api.stripe.com/'
    : 'http://localhost:4242';
