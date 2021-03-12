import 'package:flutterwave/utils/flutterwave_urls.dart';

class MobileMoneyRequest {
  String amount;
  String currency;
  String network;
  String txRef;
  String fullName;
  String email;
  String phoneNumber;
  String voucher;
  String country;
  String? redirectUrl;

  MobileMoneyRequest(
      {required this.amount,
      required this.currency,
      required this.txRef,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      this.network = "",
      this.voucher = "",
      this.country = "",
      this.redirectUrl});

  /// Converts MobileMoneyRequest instance to json
  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'network': this.network,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'email': this.email,
      'phone_number': this.phoneNumber,
      'redirect_url': (this.redirectUrl == null || this.redirectUrl!.isEmpty)
          ? FlutterwaveURLS.DEFAULT_REDIRECT_URL
          : this.redirectUrl,
      'voucher': this.voucher,
      'country': this.country
    };
  }
}
