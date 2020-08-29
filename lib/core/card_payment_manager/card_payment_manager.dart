import 'dart:convert';
import 'dart:io';
import 'package:flutterwave/core/flutterwave_error.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutterwave/interfaces/card_payment_listener.dart';
import 'package:flutterwave/models/requests/charge_card/charge_request_address.dart';
import 'package:flutterwave/models/requests/authorization.dart';
import 'package:flutterwave/models/requests/charge_card/validate_charge_request.dart';
import 'package:flutterwave/models/requests/verify_charge_request.dart';
import 'package:flutterwave/models/responses/charge_card_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:flutterwave/models/requests/charge_card/charge_card_request.dart';


class CardPaymentManager {
  String publicKey;
  String encryptionKey;
  String currency;
  String amount;
  String email;
  String fullName;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  int frequency;
  int duration;
  bool isPermanent;
  String narration;

  ChargeCardRequest chargeCardRequest;
  CardPaymentListener cardPaymentListener;

  CardPaymentManager({
    @required this.publicKey,
    @required this.encryptionKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.fullName,
    @required this.txRef,
    @required this.isDebugMode,
    this.phoneNumber,
    this.frequency,
    this.duration,
    this.isPermanent,
    this.narration,
  });
  
  CardPaymentManager setCardPaymentListener(final CardPaymentListener cardPaymentListener) {
    this.cardPaymentListener = cardPaymentListener;
    return this;
  }

  Map<String, String> _prepareRequest(
      final ChargeCardRequest chargeCardRequest) {
    final String encryptedChargeRequest = FlutterwaveUtils.TripleDESEncrypt(
        jsonEncode(chargeCardRequest.toJson()), encryptionKey);
    return FlutterwaveUtils.encryptRequest(encryptedChargeRequest);
  }

  Future<dynamic> payWithCard(
      final http.Client client,
      final ChargeCardRequest chargeCardRequest) async {
    this.chargeCardRequest = chargeCardRequest;

    if (this.cardPaymentListener == null) {
      this.cardPaymentListener.onError("No CardPaymentListener Attached!");
      return;
    }

    final Map<String, String> encryptedPayload =
    this._prepareRequest(chargeCardRequest);

    final url = FlutterwaveUtils.getBaseUrl(this.isDebugMode) + FlutterwaveUtils.CHARGE_CARD_URL;
    print("url iss ==> $url");
    final http.Response response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: this.publicKey},
        body: encryptedPayload);

    this._handleResponse(response);
  }

  void _handleResponse(final http.Response response) {
    try {
      final responseBody =
      ChargeResponse.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
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
          return this
              ._handleExtraCardAuth(responseBody, this.cardPaymentListener);
        }
        if (is3DS) {
          return this.cardPaymentListener.onRedirect(
              responseBody, responseBody.meta.authorization.redirect);
        }
        if (requiresOtp) {
          return this
              .cardPaymentListener
              .onRequireOTP(responseBody, responseBody.data.processorResponse);
        }
        return;
      }
      if (response.statusCode.toString().substring(0, 1) == "4") {
        return this.cardPaymentListener.onError(responseBody.message);
      }
      return this
          .cardPaymentListener
          .onError(jsonDecode(response.body).toString());
    } catch (e) {
      this.cardPaymentListener.onError(e.toString());
    }
  }

  void _handleExtraCardAuth(
      ChargeResponse response, CardPaymentListener listener) {
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

  Future<ChargeResponse> validatePayment(
      String otp, String flwRef, http.Client client) async {
    final url = FlutterwaveUtils.getBaseUrl(this.isDebugMode) + FlutterwaveUtils.VALIDATE_CHARGE;
    print("url iss ==> $url");
    final ValidateChargeRequest chargeRequest =
    ValidateChargeRequest(otp, flwRef);
    final payload = chargeRequest.toJson();
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload);

      final ChargeResponse cardResponse =
      ChargeResponse.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        if (cardResponse.status == FlutterwaveUtils.SUCCESS) {
          return this.verifyPayment(cardResponse.data.flwRef, client);
        }
      }

      if (response.statusCode.toString().substring(0, 1) == "4") {
        this.cardPaymentListener.onError(cardResponse.message);
      }
      return cardResponse;
    } catch (error) {
      throw (FlutterWaveError(error.toString()));
    } finally {
      client.close();
    }
   
  }

  Future<ChargeResponse> verifyPayment(
      String flwRef, http.Client client) async {
    final url = FlutterwaveUtils.getBaseUrl(this.isDebugMode) + FlutterwaveUtils.VERIFY_TRANSACTION;
    print("url iss ==> $url");
    final VerifyChargeRequest verifyRequest = VerifyChargeRequest(flwRef);
    final payload = verifyRequest.toJson();
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: payload);

      final ChargeResponse cardResponse =
      ChargeResponse.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        if (cardResponse.status == FlutterwaveUtils.SUCCESS &&
            cardResponse.data.amount == this.chargeCardRequest.amount &&
            cardResponse.data.currency == this.chargeCardRequest.currency &&
            cardResponse.data.txRef == this.chargeCardRequest.txRef) {
          return cardResponse;
        }
      }
      if (response.statusCode.toString().substring(0, 1) == "4") {
        this.cardPaymentListener.onError(cardResponse.message);
      }
      return cardResponse;
    } catch (error) {
      this.cardPaymentListener.onError(error);
    } finally {
      client.close();
    }
  }

  Future<dynamic> addPin(String pin) async {
    Authorization auth = Authorization();
    auth.mode = Authorization.PIN;
    auth.pin = pin;
    this.chargeCardRequest.authorization = auth;
    this.payWithCard(
        http.Client(), this.chargeCardRequest);
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
        http.Client(), this.chargeCardRequest);
  }

  Future<dynamic> addOTP(String otp, String flwRef) async {
    return this.validatePayment(otp, flwRef, http.Client());
  }
}
