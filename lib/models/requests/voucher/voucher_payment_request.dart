import 'package:flutter/cupertino.dart';

class VoucherPaymentRequest {
  String amount;
  String currency;
  String email;
  String txRef;
  String fullName;
  String phoneNumber;
  String pin;

  VoucherPaymentRequest({
    @required this.amount,
    @required this.currency,
    @required this.email,
    @required this.txRef,
    @required this.fullName,
    @required this.phoneNumber,
    @required this.pin,
  });

  VoucherPaymentRequest.fromJson(Map<String, dynamic> json) {
    this.amount = json['amount'];
    this.currency = json['currency'];
    this.email = json['email'];
    this.txRef = json['tx_ref'];
    this.fullName = json['fullname'];
    this.phoneNumber = json["phone_number"];
    this.pin = json["pin"];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'email': this.email,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'phone_number': this.phoneNumber,
      'pin': this.pin
    };
  }
}
