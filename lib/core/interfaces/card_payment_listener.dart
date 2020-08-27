import 'package:flutterwave/models/responses/charge_card_response/charge_card_response.dart';

abstract class CardPaymentListener {
  void onRequirePin(ChargeCardResponse response) {}

  void onRequireOTP(ChargeCardResponse response, String message) {}

  void onRequireAddress(ChargeCardResponse response) {}

  void onRedirect(ChargeCardResponse response, String url) {}

  void onError(String error) {}
}
