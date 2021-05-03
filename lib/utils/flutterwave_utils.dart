import 'package:flutterwave_port/core/flutterwave_error.dart';
import 'package:flutterwave_port/models/francophone_country.dart';
import 'package:flutterwave_port/utils/flutterwave_currency.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:tripledes/tripledes.dart';

class FlutterwaveUtils {
  /// Encrypts data using 3DES technology.
  /// Returns a String
  static String tripleDESEncrypt(dynamic data, String encryptionKey) {
    try {
      final blockCipher = BlockCipher(TripleDESEngine(), encryptionKey);
      return blockCipher.encodeB64(data);
    } catch (error) {
      throw (FlutterWaveError("Unable to encrypt request"));
    }
  }

  /// Creates a card request with encrypted details
  /// Returns a map.
  static Map<String, String> createCardRequest(String encryptedData) {
    return {"client": encryptedData};
  }

  /// Returns a list of francophone countries by their currencies
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
