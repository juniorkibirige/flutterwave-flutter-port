import 'package:flutter/material.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
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
  bool acceptBarterPayment;
  bool acceptSouthAfricaBankPayment;
  bool acceptFrancophoneMobileMoney;
  bool acceptVoucherPayment;
  String phoneNumber;
  int frequency;
  int duration;
  bool isPermanent;
  String narration;
  String country;

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
    @required this.phoneNumber,
    this.frequency,
    this.duration = 0,
    this.isPermanent = false,
    this.narration = "",
    this.acceptAccountPayment = false,
    this.acceptBankTransferPayment = false,
    this.acceptCardPayment = false,
    this.acceptUSSDPayment = false,
    this.acceptUKAccountPayment = false,
    this.acceptSouthAfricaBankPayment = false,
    this.acceptRwandaMoneyPayment = false,
    this.acceptMpesaPayment = false,
    this.acceptZambiaPayment = false,
    this.acceptGhanaPayment = false,
    this.acceptUgandaPayment = false,
    this.acceptFrancophoneMobileMoney = false,
    this.acceptBarterPayment = false,
    this.acceptVoucherPayment = false,
  }) {
    this.currency = this.currency.toUpperCase();

    if (this.currency == FlutterwaveUtils.NGN) {
      this.acceptAccountPayment = true;
      this.acceptUSSDPayment = true;
      this.acceptBankTransferPayment = true;
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
    }
    if (this.currency == FlutterwaveUtils.KES) {
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
      this.acceptMpesaPayment = true;
    }
    if (this.currency == FlutterwaveUtils.RWF) {
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
      this.acceptRwandaMoneyPayment = true;
    }
    if (this.currency == FlutterwaveUtils.UGX) {
      this.acceptUgandaPayment = true;
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
    }
    if (this.currency == FlutterwaveUtils.ZMW) {
      this.acceptZambiaPayment = true;
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
    }
    if (this.currency == FlutterwaveUtils.GHS) {
      this.acceptGhanaPayment = true;
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
    }
    if (this.currency == FlutterwaveUtils.GBP) {
      this.acceptUKAccountPayment = true;
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
    }
    if (this.currency == FlutterwaveUtils.ZAR) {
      this.acceptSouthAfricaBankPayment = true;
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
    }
    if (this.currency == FlutterwaveUtils.ZAR) {
      this.acceptVoucherPayment = true;
      this.acceptBarterPayment = true;
      this.acceptCardPayment = true;
    }
    if (this.currency == FlutterwaveUtils.XAF ||
        this.currency == FlutterwaveUtils.XOF) {
      this.acceptCardPayment = true;
      this.acceptBarterPayment = true;
      this.acceptFrancophoneMobileMoney = true;
    }
    if (this.acceptBankTransferPayment) {
      if (this.phoneNumber == null ||
          this.frequency == null ||
          this.narration == null ||
          this.duration == null) {
        throw (FlutterError(
            "To accept Bank transfer Payments, phone number, frequency, narration and duration must be supplied."));
      }
    }
  }

  String _setCountry() {
    switch (this.currency) {
      case FlutterwaveUtils.ZAR:
        return "ZA";
      case FlutterwaveUtils.NGN:
        return "NG";
      case FlutterwaveUtils.GHS:
        return "GH";
      case FlutterwaveUtils.RWF:
        return "RW";
      case FlutterwaveUtils.UGX:
        return "UG";
      case FlutterwaveUtils.ZMW:
        return "ZM";
      default:
        return "NG";
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
      duration: this.duration,
      acceptAccountPayment: this.acceptAccountPayment,
      acceptBankTransferPayment: this.acceptBankTransferPayment,
      acceptCardPayment: this.acceptCardPayment,
      acceptUSSDPayment: this.acceptUSSDPayment,
      acceptUKAccountPayment: this.acceptUKAccountPayment,
      acceptSouthAfricaBankPayment: this.acceptSouthAfricaBankPayment,
      acceptRwandaMoneyPayment: this.acceptRwandaMoneyPayment,
      acceptMpesaPayment: this.acceptMpesaPayment,
      acceptZambiaPayment: this.acceptZambiaPayment,
      acceptGhanaPayment: this.acceptGhanaPayment,
      acceptUgandaPayment: this.acceptUgandaPayment,
      acceptFancophoneMobileMoney: this.acceptFrancophoneMobileMoney,
      acceptBarterPayment: this.acceptBarterPayment,
      acceptVoucherPayment: this.acceptVoucherPayment,
      country: this._setCountry()
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
