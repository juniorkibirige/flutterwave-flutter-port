import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';

class FlutterwaveUI extends StatefulWidget {
  FlutterwaveUI(FlutterwavePaymentManager paymentManager);

  @override
  _FlutterwaveUIState createState() => _FlutterwaveUIState();
}

class _FlutterwaveUIState extends State<FlutterwaveUI> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
        ),
      ),
    );
  }
}
