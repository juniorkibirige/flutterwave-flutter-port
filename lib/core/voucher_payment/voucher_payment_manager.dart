import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/voucher/voucher_payment_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;

class VoucherPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String fullName;
  String email;
  String? redirectUrl;

  /// VoucherPaymentManager constructor
  /// returns an instance of VoucherPaymentManager
  VoucherPaymentManager({
    required this.publicKey,
    required this.isDebugMode,
    required this.amount,
    required this.currency,
    required this.email,
    required this.txRef,
    required this.fullName,
    required this.phoneNumber,
    this.redirectUrl
  });


  /// Converts this instance of VoucherPaymentManager to a Map
  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'email': this.email,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'phone_number': this.phoneNumber
    };
  }

  /// Initiates voucher payments
  /// Returns an inatance of ChargeResponse or throws an error
  Future<ChargeResponse> payWithVoucher(
      VoucherPaymentRequest payload, http.Client client) async {
    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.VOUCHER_PAYMENT;
    final uri = Uri.parse(url);
    try {
      final http.Response response = await client.post(uri,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload.toJson());

      ChargeResponse chargeResponse =
          ChargeResponse.fromJson(json.decode(response.body));
      return chargeResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    }
  }
}
