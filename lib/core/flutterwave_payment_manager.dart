import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/models/requests/authorization.dart';
import 'package:flutterwave/models/requests/charge_request_address.dart';
import 'package:flutterwave/models/requests/validate_charge_request.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/charge_card_response/charge_card_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:flutterwave/models/requests/charge_card_request.dart';

import 'interfaces/card_payment_listener.dart';

class FlutterwavePaymentManager {
  String publicKey;
  String encryptionKey;
  String currency;
  String amount;
  String email;
  String fullName;
  String txRef;
  bool isDebugMode;

  ChargeCardRequest chargeCardRequest;
  CardPaymentListener cardPaymentListener;

  FlutterwavePaymentManager({
    @required this.publicKey,
    @required this.encryptionKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.fullName,
    @required this.txRef,
    @required this.isDebugMode,
  });

  Map<String, String> _prepareRequest(
      final ChargeCardRequest chargeCardRequest) {
    final String encryptedChargeRequest = FlutterwaveUtils.TripleDESEncrypt(
        jsonEncode(chargeCardRequest.toJson()), encryptionKey);
    return FlutterwaveUtils.encryptRequest(encryptedChargeRequest);
  }

  Future<dynamic> payWithCard(
      final http.Client client,
      final ChargeCardRequest chargeCardRequest,
      final CardPaymentListener cardPaymentListener) async {
    this.chargeCardRequest = chargeCardRequest;
    this.cardPaymentListener = cardPaymentListener;

    if (this.cardPaymentListener == null) {
      this.cardPaymentListener.onError("No CardPaymentListener Attached!");
      return;
    }

    final Map<String, String> encryptedPayload =
        this._prepareRequest(chargeCardRequest);

    print("Json request is ${chargeCardRequest.toJson()}");
    print("Encrypted request is $encryptedPayload");

    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.CHARGE_CARD_URL;
    final http.Response response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: this.publicKey},
        body: encryptedPayload);

    this._handleResponse(response);
  }

  void _handleResponse(final http.Response response) {
    try {
      final responseBody =
          ChargeCardResponse.fromJson(jsonDecode(response.body));
      print("body is ${responseBody.toJson()}");

      if (response.statusCode == 200) {
        print("Status code is 200");
        final bool requiresExtraAuth =
            (responseBody.message == FlutterwaveUtils.REQUIRES_AUTH) &&
                (responseBody.meta.authorization.mode != null);

        final bool is3DS = (responseBody.message ==
                FlutterwaveUtils.CHARGE_INITIATED) &&
            (responseBody.meta.authorization.mode == Authorization.REDIRECT);

        final bool requiresOtp =
            (responseBody.message == FlutterwaveUtils.CHARGE_INITIATED) &&
                (responseBody.meta.authorization.mode == Authorization.OTP);

        if (requiresExtraAuth) {
          print("requires Authhhh");
          return this
              ._handleExtraCardAuth(responseBody, this.cardPaymentListener);
        }
        if (is3DS) {
          print("requires 3DS ");
          return this.cardPaymentListener.onRedirect(
              responseBody, responseBody.meta.authorization.redirect);
        }
        if (requiresOtp) {
          print("requires validation");
          return this
              .cardPaymentListener
              .onRequireOTP(responseBody, responseBody.data.processorResponse);
        }

        print("requires validation herrrrrrreeeeee");
        return;
      }
      if (response.statusCode.toString().substring(0, 1) == "4") {
        return this.cardPaymentListener.onError(responseBody.message);
      }
      print("Response code is ${response.statusCode}");
      return this
          .cardPaymentListener
          .onError(jsonDecode(response.body).toString());
    } catch (e) {
      print("Error is ${e.toString()}");
      print("Error instance is $e");
      this.cardPaymentListener.onError(e.toString());
    }
  }

  void _handleExtraCardAuth(
      ChargeCardResponse response, CardPaymentListener listener) {
    final String authMode = response.meta.authorization.mode;
    if (Authorization.AVS == authMode) {
      return this.cardPaymentListener.onRequireAddress(response);
    }
    if (Authorization.REDIRECT == authMode) {
      return this
          .cardPaymentListener
          .onRedirect(response, response.meta.authorization.redirect);
    }
    if (Authorization.OTP == authMode) {
      return this
          .cardPaymentListener
          .onRequireOTP(response, response.data.processorResponse);
    }
    if (Authorization.PIN == authMode)
      return this.cardPaymentListener.onRequirePin(response);
    return;
  }

  Future<ChargeCardResponse> validatePayment(
      String otp, String flwRef, http.Client client) async {
    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.VALIDATE_CHARGE;
    final ValidateChargeRequest chargeRequest =
        ValidateChargeRequest(otp, flwRef);
    final payload = chargeRequest.toJson();
    final http.Response response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: this.publicKey},
        body: payload);

    final ChargeCardResponse cardResponse =
        ChargeCardResponse.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      if (cardResponse.status == FlutterwaveUtils.SUCCESS) {
        return this.verifyPayment(cardResponse.data.flwRef, client);
      }
    }

    if (response.statusCode.toString().substring(0, 1) == "4") {
      this.cardPaymentListener.onError(cardResponse.message);
    }

    print("validate response status ${response.statusCode}");
    print("validate response body ${jsonEncode(response.body)}");
    return cardResponse;
  }

  Future<ChargeCardResponse> verifyPayment(
      String flwRef, http.Client client) async {
    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.VERIFY;
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload);

      final ChargeCardResponse cardResponse =
          ChargeCardResponse.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        if (cardResponse.status == FlutterwaveUtils.SUCCESS &&
            cardResponse.data.amount == this.chargeCardRequest.amount &&
            cardResponse.data.currency == this.chargeCardRequest.currency &&
            cardResponse.data.txRef == this.chargeCardRequest.txRef
        ) {
          print("verification successful ${cardResponse.toJson()}");
        }
      }
      if (response.statusCode.toString().substring(0, 1) == "4") {
        this.cardPaymentListener.onError(cardResponse.message);
      }
      print("verify response status ${response.statusCode}");
      print("verify response body ${jsonEncode(response.body)}");
      return cardResponse;
    } catch (error) {
      throw (error);
    }
  }

  Future<dynamic> addPin(String pin) async {
    Authorization auth = Authorization();
    auth.mode = Authorization.PIN;
    auth.pin = pin;
    this.chargeCardRequest.authorization = auth;
    this.payWithCard(
        http.Client(), this.chargeCardRequest, this.cardPaymentListener);
  }

  Future<dynamic> addAddress(ChargeRequestAddress chargeAddress) async {
    Authorization auth = Authorization();
    auth.mode = Authorization.AVS;
    auth.address = chargeAddress.address;
    auth.city = chargeAddress.city;
    auth.state = chargeAddress.state;
    auth.zipcode = chargeAddress.zipCode;
    auth.country = chargeAddress.country;

    this.chargeCardRequest.authorization = auth;
    this.payWithCard(
        http.Client(), this.chargeCardRequest, this.cardPaymentListener);
  }

  Future<dynamic> addOTP(String otp, String flwRef) async {
    return this.validatePayment(otp, flwRef, http.Client());
  }
}
