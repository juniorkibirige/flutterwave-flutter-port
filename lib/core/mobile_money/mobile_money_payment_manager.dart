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

  /// MobileMoneyPaymentManager constructor
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


  /// Initiates payments via Mobile Money
  /// returns an instance of ChargeResponse or throws an error
  Future<ChargeResponse> payWithMobileMoney(
      MobileMoneyRequest mobileMoneyRequest, http.Client client) async {
    final requestBody = mobileMoneyRequest.toJson();
    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.getMobileMoneyUrl(this.currency);
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);
      ChargeResponse chargeResponse = ChargeResponse.fromJson(json.decode(response.body));
      return chargeResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    }
  }
}
