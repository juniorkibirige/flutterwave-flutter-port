import 'package:tripledes/tripledes.dart';

class FlutterwaveUtils {
  static const String BASE_URL = "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/";
  static const String CHARGE_CARD_URL = "charges?type=card";
  static const String VALIDATE_CHARGE = "validate-charge";
  static const String VERIFY = "mpesa-verify";
  static const String DEFAULT_REDIRECT_URL = "https://flutterwave.com/ng/";

  static const String CHARGE_INITIATED = "Charge initiated";
  static const String REQUIRES_AUTH = "Charge authorization data required";
  static const String SUCCESS = "success";

  static String TripleDESEncrypt(dynamic data, String encryptionKey) {
    final blockCipher = BlockCipher(TripleDESEngine(), encryptionKey);
    return blockCipher.encodeB64(data);
  }

  static Map<String, String> encryptRequest(String encryptedData) {
    return { "client": encryptedData };
  }
}