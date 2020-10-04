import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/mobile_money/mobile_money_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;

class MobileMoneyPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String network;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String fullName;
  String email;

  MobileMoneyPaymentManager({
    @required this.publicKey,
    @required this.currency,
    @required this.amount,
    @required this.txRef,
    @required this.isDebugMode,
    @required this.phoneNumber,
    @required this.fullName,
    @required this.email,
    this.network,
  });

  Future<ChargeResponse> payWithMobileMoney(
      MobileMoneyRequest mobileMoneyRequest, http.Client client) async {
    final requestBody = mobileMoneyRequest.toJson();
    print("MM Request is $requestBody");
    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.getMobileMoneyUrl(this.currency);
    print("MM URL is $url");
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);
      ChargeResponse chargeResponse = ChargeResponse.fromJson(json.decode(response.body));
      return chargeResponse;
    } catch (error, stackTrace) {
      throw (FlutterError(error.toString()));
    }
  }
}
