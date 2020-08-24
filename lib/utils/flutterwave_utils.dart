import 'package:tripledes/tripledes.dart';

class FlutterwaveUtils {
  static const String CHARGE_CARD_URL = "/charges?type=card";
  static const String BASE_URL = "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout";

  static String TripleDESEncrypt(dynamic data, String encryptionKey) {
    final blockCipher = BlockCipher(TripleDESEngine(), encryptionKey);
    return blockCipher.encodeB64(data);
  }

  static Map<String, String> encryptRequest(String encryptedData) {
    return { "client": encryptedData };
  }
}