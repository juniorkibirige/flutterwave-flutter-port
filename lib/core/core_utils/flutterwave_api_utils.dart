import 'dart:convert';
import 'dart:io';

import 'package:flutterwave/core/flutterwave_error.dart';
import 'package:flutterwave/core/metrics/metric_manager.dart';
import 'package:flutterwave/models/requests/charge_card/validate_charge_request.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/models/responses/get_bank/get_bank_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;


/// Flutterwave Utility class
class FlutterwaveAPIUtils {

  /// This method fetches a list of Nigerian banks
  /// it returns an instance of GetBanksResponse or throws an error
  static Future<List<GetBanksResponse>> getBanks(
      final http.Client client) async {
    try {
      final response = await client.get(
        FlutterwaveURLS.GET_BANKS_URL,
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonDecoded = jsonDecode(response.body);
        final banks =
            jsonDecoded.map((json) => GetBanksResponse.fromJson(json)).toList();

        return banks;
      } else {
        throw (FlutterWaveError("Unable to fetch banks. Please contact support"));
      }
    } catch (error) {
      throw (FlutterWaveError(error.toString()));
    } finally {
      client.close();
    }
  }


  /// Validates payments with OTP
  /// returns an instance of ChargeResponse or throws an error
  static Future<ChargeResponse> validatePayment(
      String otp, String flwRef,
      http.Client client,
      final bool isDebugMode,
      final String publicKey,
      final isBankAccount,
      [String feature = ""]) async {
    final stopWatch = Stopwatch();

    final url = FlutterwaveURLS.getBaseUrl(isDebugMode) + FlutterwaveURLS.VALIDATE_CHARGE;
    final ValidateChargeRequest chargeRequest =
    ValidateChargeRequest(otp, flwRef, isBankAccount);
    final payload = chargeRequest.toJson();
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: publicKey},
          body: payload);

      if (feature.isNotEmpty) {
        MetricManager.
        logMetric(client,
            publicKey,
            feature,
            "${stopWatch.elapsedMilliseconds}ms");
      }
      final ChargeResponse cardResponse =
      ChargeResponse.fromJson(jsonDecode(response.body));
      return cardResponse;
    } catch (error) {
      if (feature.isNotEmpty) {
        MetricManager
            .logMetric(client,
            publicKey, "{$feature}_ERROR",
            "${stopWatch.elapsedMilliseconds}ms");
      }
      throw (FlutterWaveError(error.toString()));
    }
  }


  /// Verifies payments with Flutterwave reference
  /// returns an instance of ChargeResponse or throws an error
  static Future<ChargeResponse> verifyPayment(
      final String flwRef,
      final http.Client client,
      final String publicKey,
      final bool isDebugMode,
      [String feature = ""]) async {
    final stopWatch = Stopwatch();

    final url = FlutterwaveURLS.getBaseUrl(isDebugMode) +
        FlutterwaveURLS.VERIFY_TRANSACTION;
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    try {
      stopWatch.start();
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: publicKey}, body: payload);
      stopWatch.stop();
      final ChargeResponse cardResponse =
          ChargeResponse.fromJson(jsonDecode(response.body));
      if (feature.isNotEmpty) {
        MetricManager.logMetric(client, publicKey, feature, "${stopWatch.elapsedMilliseconds}ms");
      }
      return cardResponse;
    } catch (error) {
      if (feature.isNotEmpty) {
        MetricManager
            .logMetric(client,
            publicKey, "{$feature}_ERROR",
            "${stopWatch.elapsedMilliseconds}ms");
      }
      throw (FlutterWaveError(error.toString()));
    } 
  }
}
