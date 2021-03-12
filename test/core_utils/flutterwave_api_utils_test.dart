import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwave/core/core_utils/flutterwave_api_utils.dart';
import 'package:flutterwave/models/requests/charge_card/validate_charge_request.dart';
import 'package:flutterwave/models/responses/charge_card_response/charge_card_response_data.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/models/responses/get_bank/get_bank_response.dart';
import 'package:flutterwave/utils/flutterwave_urls.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class MockChargeResponse extends Mock implements ChargeResponse { }

main() {
  group('getBanks', () {
    test('returns a list of banks if it completes successfully', () async {
      final bankResult = [
        {
          "bankname": "ACCESS BANK NIGERIA",
          "bankcode": "044",
          "internetbanking": false
        },
        {
          "bankname": "FIRST BANK PLC",
          "bankcode": "011",
          "internetbanking": false
        },
        {"bankname": "GTBANK PLC", "bankcode": "058", "internetbanking": false},
        {
          "bankname": "ZENITH BANK PLC",
          "bankcode": "057",
          "internetbanking": false
        }
      ];

      final response = jsonEncode(bankResult);
      final client = MockClient();
      final mockResponse = MockResponse();
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(response);

      when(client.get(Uri.https(FlutterwaveURLS.GET_BANKS_URL, "")))
          .thenAnswer((_) async => mockResponse);

      expect(200, mockResponse.statusCode);
      expect(await FlutterwaveAPIUtils.getBanks(client),
          isA<List<GetBanksResponse>>());
      verify(client.close()).called(1);

    });
  });

  group("Validate payment method", () {
    test("should work correctly", () async {
      final client = MockClient();
      final mockResponse = MockResponse();
      final mockChargeResponse = MockChargeResponse();
      final mockChargeResponseData = ChargeResponseData();
      final isDebugMode = false;
      final flwRef = "some_ref";
      final otp = "123445";
      final String publicKey = "publicKey";
      final url = FlutterwaveURLS.getBaseUrl(isDebugMode) + FlutterwaveURLS.VALIDATE_CHARGE;
      final uri = Uri.https(url, "");
      final mockHeaders = {HttpHeaders.authorizationHeader: publicKey};
      final payload = ValidateChargeRequest(otp, flwRef, false).toJson();

      final resp = {
        "status": "success",
        "message": "Charge initiated",
        "data": {
          "id": 1564963,
          "tx_ref": "MC-1858523v508",
          "flw_ref": "FLW322821601200978281",
          "device_fingerprint": "N/A",
          "amount": 38005,
          "charged_amount": 38005,
          "app_fee": 532.07,
          "merchant_fee": 0,
          "processor_response": "Transaction in progress",
          "auth_model": "AUTH",
          "currency": "XOF",
          "ip": "::ffff:10.93.223.38",
          "narration": "FredDominant",
          "status": "pending",
          "payment_type": "mobilemoneysn",
          "fraud_status": "ok",
          "charge_type": "normal",
          "created_at": "2020-09-27T10:02:56.000Z",
          "account_id": 157271,
          "customer": {
            "id": 460650,
            "phone_number": "08163113683",
            "name": "John Madakin",
            "email": "user@flw.com",
            "created_at": "2020-09-10T15:47:37.000Z"
          }
        },
        "meta": {
          "authorization": {
            "mode": "callback",
            "redirect_url": null
          }
        }
      };

      when(mockChargeResponse.toJson()).thenReturn(resp);

      final response = jsonEncode(resp);

      when(mockChargeResponse.data).thenReturn(mockChargeResponseData);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(response);
      when(client.post(uri, body: payload, headers: mockHeaders)).thenAnswer((_) async => mockResponse);

      expect(200, mockResponse.statusCode);
      expect(await FlutterwaveAPIUtils
          .validatePayment(otp, flwRef, client, isDebugMode, publicKey, false),
      isA<ChargeResponse>());
    });
  });
}
