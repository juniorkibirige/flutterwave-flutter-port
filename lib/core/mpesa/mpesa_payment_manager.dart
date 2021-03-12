import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/mpesa/mpesa_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;

class MpesaPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String fullName;
  String email;
  String? redirectUrl;

  /// MpesaPaymentManager constructor.
  MpesaPaymentManager(
      {required this.publicKey,
      required this.isDebugMode,
      required this.amount,
      required this.currency,
      required this.email,
      required this.txRef,
      required this.fullName,
      required this.phoneNumber,
      this.redirectUrl});

  /// Converts instance of MpesaPaymentManager to a map
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

  /// Initiates payments via Mpesa
  /// Available for only payments with KES currency
  /// returns an instance of ChargeResponse or throws an error
  Future<ChargeResponse> payWithMpesa(
      MpesaRequest payload, http.Client client) async {
    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.PAY_WITH_MPESA;
    final uri = Uri.parse(url);
    try {

      final http.Response response = await client.post(uri,
          headers: {
            HttpHeaders.authorizationHeader: this.publicKey,
            HttpHeaders.contentTypeHeader:'application/json'
          },
          body: json.encode(payload.toJson()));

      ChargeResponse chargeResponse =
          ChargeResponse.fromJson(json.decode(response.body));

      return chargeResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    } finally {
      client.close();
    }
  }
}
