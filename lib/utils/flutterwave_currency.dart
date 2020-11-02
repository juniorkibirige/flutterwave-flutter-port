class FlutterwaveCurrency {
  static const String NGN = "NGN";
  static const String KES = "KES";
  static const String RWF = "RWF";
  static const String UGX = "UGX";
  static const String ZMW = "ZMW";
  static const String GHS = "GHS";
  static const String XAF = "XAF";
  static const String XOF = "XOF";

//TODO to be added when available on v3
// static const String GBP = "GBP";
// static const String ZAR = "ZAR";

  /// Returns a list of Mobile Money Networks available in a country
  static List<String> getAllowedMobileMoneyNetworksByCurrency(
      final String currency) {
    switch (currency) {
      case GHS:
        return ["MTN", "VODAFONE", "TIGO", "AIRTEL"];
      case UGX:
        return [];
      case RWF:
        return [];
      case ZMW:
        return [];
    }
    return [];
  }
}