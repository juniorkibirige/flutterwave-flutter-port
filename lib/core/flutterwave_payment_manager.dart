import 'dart:io';
import 'package:flutterwave/models/responses/charge_card_response/charge_card_response.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/cupertino.dart';
import 'package:flutterwave/models/requests/charge_card_request.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';

class FlutterwavePaymentManager {
  String publicKey;
  String encryptionKey;
  bool isDebugMode;
  ChargeCardRequest chargeCardRequest;

  FlutterwavePaymentManager({
    @required this.publicKey,
    @required this.encryptionKey,
    @required this.isDebugMode,
  });

  Future<dynamic> payWithCard(final http.Client client, final ChargeCardRequest chargeCardRequest) async {
    this.chargeCardRequest = chargeCardRequest;
    final String encryptedChargeRequest = FlutterwaveUtils.TripleDESEncrypt(chargeCardRequest.toJson(), encryptionKey);
    final Map<String, String> encryptedPayload = FlutterwaveUtils.encryptRequest(encryptedChargeRequest);
    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.CHARGE_CARD_URL;
    final http.Response response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: this.publicKey},
        body: encryptedPayload);

  }

}
