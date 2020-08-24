import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';

import 'package:flutterwave/widgets/flutterwave_payment.dart';

class Flutterwave {
  BuildContext context;
  String publicKey;
  String encryptionKey;
  bool isDebugMode;
  bool acceptAccountPayment;
  bool acceptBankTransferPayment;
  bool acceptCardPayment;
  bool acceptUSSDPayment;
  bool acceptUKAccountPayment;
  bool acceptRwandaMoneyPayment;
  bool acceptMpesaPayment;
  bool acceptZambiaPayment;
  bool acceptGhanaPayment;
  bool acceptUgandaPayment;

  Flutterwave.UIPayment({
    @required this.context,
    this.publicKey,
    this.encryptionKey,
    this.isDebugMode,
    this.acceptAccountPayment,
    this.acceptBankTransferPayment,
    this.acceptCardPayment,
    this.acceptUSSDPayment,
    this.acceptUKAccountPayment,
    this.acceptRwandaMoneyPayment,
    this.acceptMpesaPayment,
    this.acceptZambiaPayment,
    this.acceptGhanaPayment,
    this.acceptUgandaPayment
  });

  void initialize() {
    FlutterwavePaymentManager paymentManager = FlutterwavePaymentManager(
        publicKey: this.publicKey, isDebugMode: this.isDebugMode);
    if (this.context == null) { }
    return this._launchPaymentScreen(paymentManager);
  }

  void _launchPaymentScreen(final FlutterwavePaymentManager paymentManager) {
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => FlutterwaveUI(paymentManager)),
    );
  }
}
