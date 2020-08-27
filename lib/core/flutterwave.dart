import 'package:flutter/material.dart';
import 'package:flutterwave/widgets/card_payment/flutterwave_payment.dart';

import 'flutterwave_payment_manager.dart';

class Flutterwave {
  BuildContext context;
  String publicKey;
  String encryptionKey;
  bool isDebugMode;
  String amount;
  String currency;
  String email;
  String fullName;
  String txRef;
  String redirectUrl;
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

  Flutterwave.UiPayment({
    @required this.context,
    @required this.publicKey,
    @required this.encryptionKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.fullName,
    @required this.txRef,
    @required this.isDebugMode,
    this.acceptAccountPayment = false,
    this.acceptBankTransferPayment = false,
    this.acceptCardPayment = false,
    this.acceptUSSDPayment = false,
    this.acceptUKAccountPayment = false,
    this.acceptRwandaMoneyPayment = false,
    this.acceptMpesaPayment = false,
    this.acceptZambiaPayment = false,
    this.acceptGhanaPayment = false,
    this.acceptUgandaPayment = false,
  });

  void initialize() {
    FlutterwavePaymentManager paymentManager = FlutterwavePaymentManager(
      publicKey: this.publicKey,
      encryptionKey: this.encryptionKey,
      currency: this.currency,
      email: this.email,
      fullName: this.fullName,
      amount: this.amount,
      txRef: this.txRef,
      isDebugMode: this.isDebugMode,
    );
    if (this.context == null) {}
    return this._launchPaymentScreen(paymentManager);
  }

  void _launchPaymentScreen(final FlutterwavePaymentManager paymentManager) {
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => FlutterwaveUI(paymentManager)),
    );
  }
}
