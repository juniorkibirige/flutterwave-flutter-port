import 'package:flutterwave/models/francophone_country.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:tripledes/tripledes.dart';

class FlutterwaveUtils {
  static String tripleDESEncrypt(dynamic data, String encryptionKey) {
    final blockCipher = BlockCipher(TripleDESEngine(), encryptionKey);
    return blockCipher.encodeB64(data);
  }

  static Map<String, String> encryptRequest(String encryptedData) {
    return {"client": encryptedData};
  }

  static List<FrancoPhoneCountry> getFrancoPhoneCountries(
      final String currency) {
    if (currency == FlutterwaveCurrency.XAF)
      return [FrancoPhoneCountry("CAMEROON", "CM")];
    return [
      FrancoPhoneCountry("BURKINA FASO", "BF"),
      FrancoPhoneCountry("COTE D'IVOIRE", "CI"),
      FrancoPhoneCountry("GUINEA", "GN"),
      FrancoPhoneCountry("SENEGAL", "SN"),
    ];
  }
}
