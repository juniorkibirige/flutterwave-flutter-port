import 'package:tripledes/tripledes.dart';

class FlutterwaveUtils {
  static const String _DEBUG_BASE_URL = "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/";
  static const String _PROD_BASE_URL = "https://api.ravepay.co/v3/sdkcheckout/";
  static const String CHARGE_CARD_URL = "charges?type=card";
  static const String BANK_TRANSFER = "charges?type=bank_transfer";
  static const String PAY_WITH_ACCOUNT = "charges?type=debit_ng_account";
  static const String GET_BANKS_URL = "https://api.ravepay.co/flwv3-pug/getpaidx/api/flwpbf-banks.js?json=1";


  static const String VALIDATE_CHARGE = "validate-charge";
  static const String VERIFY_TRANSACTION = "mpesa-verify";

  static const String DEFAULT_REDIRECT_URL = "https://flutterwave.com/ng/";

  static const String CHARGE_INITIATED = "Charge initiated";
  static const String REQUIRES_AUTH = "Charge authorization data required";
  static const String SUCCESS = "success";
  static const String ERROR =   "error";
  static const String SUCCESSFUL = "successful";
  static const String APPROVED_SUCCESSFULLY =   "Approved successfully";

  static String TripleDESEncrypt(dynamic data, String encryptionKey) {
    final blockCipher = BlockCipher(TripleDESEngine(), encryptionKey);
    return blockCipher.encodeB64(data);
  }

  static Map<String, String> encryptRequest(String encryptedData) {
    return { "client": encryptedData };
  }

  static String getBaseUrl(final bool isDebugMode) {
    return isDebugMode ? _DEBUG_BASE_URL : _PROD_BASE_URL;
  }
}