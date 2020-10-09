import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_error.dart';
import 'package:flutterwave/models/requests/pay_with_bank_account/pay_with_bank_account.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;

class BankAccountPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String email;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String accountBank;
  String accountNumber;
  String fullName;
  
  
  BankAccountPaymentManager({
    @required this.publicKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.txRef,
    @required this.isDebugMode,
    @required this.phoneNumber,
    @required this.accountBank,
    @required this.accountNumber,
    @required this.fullName
  });

  Future<ChargeResponse> payWithAccount(
      BankAccountPaymentRequest bankAccountRequest, http.Client client) async {
    final requestBody = bankAccountRequest.toJson();

    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) + FlutterwaveURLS.PAY_WITH_ACCOUNT;
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);

      ChargeResponse bankTransferResponse =
      ChargeResponse.fromJson(json.decode(response.body));
      return bankTransferResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    }
  }

  Future<ChargeResponse> verifyPayment(final String flwRef, final http.Client client) async {
    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) + FlutterwaveURLS.VERIFY_TRANSACTION;
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload);

      final ChargeResponse cardResponse =
      ChargeResponse.fromJson(jsonDecode(response.body));
      return cardResponse;
    } catch (error) {
      throw(FlutterWaveError(error.toString()));
    }
  }
}
