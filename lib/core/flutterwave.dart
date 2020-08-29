import 'package:flutter/material.dart';
import 'package:flutterwave/widgets/home/flutterwave_payment.dart';

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
  String phoneNumber;
  int frequency;
  int duration;
  bool isPermanent;
  String narration;

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
    this.phoneNumber,
    this.frequency,
    this.duration = 0,
    this.isPermanent = false,
    this.narration = "",
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
  }) {
    if (this.acceptBankTransferPayment) {
      if (this.phoneNumber == null || this.frequency == null || this.narration == null || this.duration == null) {
        throw (FlutterError("To accept Bank transfer Payments, phone number, frequency, narration and duration must be supplied."));
      }
    }
  }

  void initializeForUiPayments() {
    FlutterwavePaymentManager paymentManager = FlutterwavePaymentManager(
      publicKey: this.publicKey,
      encryptionKey: this.encryptionKey,
      currency: this.currency,
      email: this.email,
      fullName: this.fullName,
      amount: this.amount,
      txRef: this.txRef,
      isDebugMode: this.isDebugMode,
      narration: this.narration,
      isPermanent: this.isPermanent,
      phoneNumber: this.phoneNumber,
      frequency: this.frequency,
      duration: this.duration
    );
    return this._launchPaymentScreen(paymentManager);
  }

  void _launchPaymentScreen(final FlutterwavePaymentManager paymentManager) {
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => FlutterwaveUI(paymentManager)),
    );
  }
}
