import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwave_port/models/requests/bank_transfer/bank_transfer_request.dart';
import 'package:flutterwave_port/models/requests/charge_card/charge_card_request.dart';
import 'package:flutterwave_port/models/requests/charge_card/validate_charge_request.dart';
import 'package:flutterwave_port/utils/flutterwave_currency.dart';
import 'package:flutterwave_port/utils/flutterwave_urls.dart';

main() {
  group("Bank Transfer Request", () {
    final bankTransferRequest = BankTransferRequest(
        amount: "100",
        currency: FlutterwaveCurrency.NGN,
        duration: "3",
        email: "email.com",
        frequency: "3",
        isPermanent: "false",
        narration: "some narration",
        txRef: "some_ref",
        phoneNumber: "12345");

    test("objects should initialize correctly", () {
      expect(bankTransferRequest.amount, "100");
      expect(bankTransferRequest.currency, "NGN");
      expect(bankTransferRequest.frequency, "3");
    });

    test("toJson() should work correctly", () {
      final Map<String, dynamic>? json = bankTransferRequest.toJson();

      expect(json != null, true);
      expect(json!["narration"], "some narration");
      expect("12345", json["phone_number"]);
      expect("email.com", json["email"]);
    });

    test("should initiate objects properly fromJson()", () {
      final json = bankTransferRequest.toJson();
      final bt = BankTransferRequest.fromJson(json);

      expect(true, bt.runtimeType == BankTransferRequest().runtimeType);
      expect(bt.narration, json["narration"]);
      expect(bt.phoneNumber, json["phone_number"]);
      expect(bt.email, json["email"]);
    });
  });

  group("Charge Card Request", () {
    final chargeCardRequest = ChargeCardRequest(
        amount: "100",
        currency: FlutterwaveCurrency.GHS,
        cardNumber: "1234567890",
        email: "email.com",
        expiryMonth: "12",
        cvv: "419",
        expiryYear: "2090",
        fullName: "FredDominant Tha Boss",
        txRef: "some_ref");

    test("objects should initialize correctly", () {
      expect("100", chargeCardRequest.amount);
      expect("GHS", chargeCardRequest.currency);
      expect("12", chargeCardRequest.expiryMonth);
      expect(true, chargeCardRequest.authorization == null);
      expect(
          chargeCardRequest.redirectUrl, FlutterwaveURLS.DEFAULT_REDIRECT_URL);
    });

    test("toJson() should work correctly", () {
      final Map<String, dynamic>? json = chargeCardRequest.toJson();

      expect(true, json != null);
      expect("419", json!["cvv"]);
      expect("100", json["amount"]);
      expect("email.com", json["email"]);
      expect(true, json["authorization"] != null);
    });
  });

  group("Validate Card Request", () {
    final validateChargeRequest = ValidateChargeRequest("123", "GHS");

    test("objects should initialize correctly", () {
      expect("123", validateChargeRequest.otp);
      expect("GHS", validateChargeRequest.flwRef);
      expect(false, validateChargeRequest.isBankAccount);
    });

// Corrected Test to run smoothly
    test("toJson() should work correctly", () {
      final Map<String, dynamic>? json = validateChargeRequest.toJson();

      expect(json != null, true);
      expect(json!["otp"], "123");
      expect(json["flw_ref"], "GHS");
      expect(json["type"], null);
    });

    test("fromJson() should work correctly", () {
      final Map<String, dynamic>? json = validateChargeRequest.toJson();
      final vcr = ValidateChargeRequest.fromJson(json!);
      expect(vcr.otp, json["otp"]);
      expect(vcr.flwRef, json["flw_ref"]);
    });
  });
}
