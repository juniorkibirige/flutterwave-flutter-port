import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave/core/metrics/metric_manager.dart';
import 'package:flutterwave/models/requests/pay_with_bank_account/pay_with_bank_account.dart';
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
  String? accountBank;
  String? accountNumber;
  String fullName;
  String? redirectUrl;

  /// BankAccountPaymentManager constructor
  /// Available for only payments with NGN currency
  BankAccountPaymentManager({
    required this.publicKey,
    required this.currency,
    required this.amount,
    required this.email,
    required this.txRef,
    required this.isDebugMode,
    required this.phoneNumber,
    required this.fullName,
    this.accountBank,
    this.accountNumber,
    this.redirectUrl,
  });

  /// Initiates payments via Bank Account
  /// Available for only payments with NGN currency
  /// returns an instance of ChargeResponse or throws an error
  Future<ChargeResponse> payWithAccount(
      BankAccountPaymentRequest bankAccountRequest, http.Client client) async {
    final stopWatch = Stopwatch();
    final requestBody = bankAccountRequest.toJson();

    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.PAY_WITH_ACCOUNT;
    final uri = Uri.parse(url);
    try {
      final http.Response response = await client.post(uri,
          headers: {
            HttpHeaders.authorizationHeader: this.publicKey,
            HttpHeaders.contentTypeHeader: "application/json"
          },
          body: jsonEncode(requestBody));

      MetricManager.logMetric(
          client,
          publicKey,
          MetricManager.INITIATE_ACCOUNT_CHARGE,
          "${stopWatch.elapsedMilliseconds}ms");

      ChargeResponse bankTransferResponse =
          ChargeResponse.fromJson(json.decode(response.body));

      return bankTransferResponse;
    } catch (error) {

      MetricManager.logMetric(
          client,
          publicKey,
          MetricManager.INITIATE_ACCOUNT_CHARGE_ERROR,
          "${stopWatch.elapsedMilliseconds}ms");
      throw (FlutterError(error.toString()));
    }
  }
}
