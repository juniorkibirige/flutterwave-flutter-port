import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_error.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/bank_transfer_response/bank_transfer_response.dart';
import 'package:flutterwave/models/responses/charge_card_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/models/requests/bank_transfer/bank_transfer_request.dart';

class BankTransferPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String email;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  int frequency;
  int duration;
  bool isPermanent;
  String narration;

  BankTransferPaymentManager({
    @required this.publicKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.txRef,
    @required this.isDebugMode,
    @required this.phoneNumber,
    @required this.frequency,
    @required this.narration,
    this.duration,
    this.isPermanent,
  });

  Future<BankTransferResponse> payWithBankTransfer(
      BankTransferRequest bankTransferRequest, http.Client client) async {
    final requestBody = bankTransferRequest.toJson();

    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.BANK_TRANSFER;

    try {
      print("Pay With Transfer Request Payload => ${bankTransferRequest.toJson()}");

      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);

      BankTransferResponse bankTransferResponse =
          BankTransferResponse.fromJson(json.decode(response.body));

      print("Pay with transfer response => ${bankTransferResponse.toJson()}");

      return bankTransferResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    }
  }

  Future<ChargeResponse> verifyPayment(final String flwRef, final http.Client client) async {
    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.VERIFY_TRANSACTION;
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    print("Verify Transfer Url => $url");
    print("Verify Transfer Request Payload => ${verifyRequest.toJson()}");
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload);

      final ChargeResponse cardResponse =
      ChargeResponse.fromJson(jsonDecode(response.body));
      print("Verify Transfer Response Payload => ${cardResponse.toJson()}");
      
      return cardResponse;
    } catch (error) {
      throw(FlutterWaveError(error.toString()));
    }
  }
}
