import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/ussd/ussd_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;

class USSDPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String email;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String fullName;

  USSDPaymentManager({
    @required this.publicKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.txRef,
    @required this.isDebugMode,
    @required this.phoneNumber,
    @required this.fullName,
  });

  Future<ChargeResponse> payWithUSSD(
      USSDRequest ussdRequest, http.Client client) async {
    final requestBody = ussdRequest.toJson();

    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.PAY_WITH_USSD;
    print("url iss ==> $url");

    try {
      print(
          "Pay With USSD Request Payload => ${ussdRequest.toJson()}");

      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);

      ChargeResponse chargeResponse =
      ChargeResponse.fromJson(json.decode(response.body));

      print("Pay with USSD response => ${chargeResponse.toJson()}");

      return chargeResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    } finally {
      client.close();
    }
  }
}
