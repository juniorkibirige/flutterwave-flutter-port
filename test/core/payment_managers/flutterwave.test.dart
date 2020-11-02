import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements BuildContext {}
class MockChargeResponse extends Mock implements ChargeResponse {}
class MockFlutterWave extends Mock implements Flutterwave {}
main() {
  group("Flutterwave core", () {
    test("should initialize correctly", () {
      final mockContext = MockContext();
      final String pbKey = "pbKey";
      final String enKey = "enKey";
      final String currency = FlutterwaveCurrency.UGX;
      final String amount = "100";
      final String email = "email@email.com";
      final String fullName = "Full Name";
      final String txref = "tx_r_ef";
      final bool isDebugMode = true;
      final String phoneNumber = "123456";
      final flutterwave = Flutterwave.forUIPayment(context: mockContext,
          publicKey: pbKey,
          encryptionKey: enKey,
          currency: currency,
          amount: amount,
          email: email,
          fullName: fullName,
          txRef: txref,
          isDebugMode: isDebugMode,
          phoneNumber: phoneNumber);

      expect(true, flutterwave.runtimeType == Flutterwave);
      expect(true, flutterwave.acceptUgandaPayment);
      expect(false, flutterwave.acceptAccountPayment);
      expect(false, flutterwave.acceptFrancophoneMobileMoney);
      expect(false, flutterwave.acceptZambiaPayment);
      expect(true, flutterwave.narration.isEmpty);
      expect(0, flutterwave.duration);
      expect(txref, flutterwave.txRef);
      expect(currency, flutterwave.currency);
    });

    test("initializeForUiPayments() should return ChargeResponse", () async {
      final mockResponse = MockChargeResponse();
      final flutterwave = MockFlutterWave();
      when(mockResponse.status).thenReturn("success");
      when(flutterwave.initializeForUiPayments())
      .thenAnswer((_) => Future.value(mockResponse));
      final result = await flutterwave.initializeForUiPayments();
      print(result.runtimeType);
      expect("success", result.status);
      verify(await flutterwave.initializeForUiPayments()).called(1);
    });
  });
}