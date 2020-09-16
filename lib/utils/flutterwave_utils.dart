import 'package:flutterwave/models/francophone_country.dart';
import 'package:tripledes/tripledes.dart';

class FlutterwaveUtils {
  static const String _DEBUG_BASE_URL =
      "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/";
  static const String _PROD_BASE_URL = "https://api.ravepay.co/v3/sdkcheckout/";
  static const String CHARGE_CARD_URL = "charges?type=card";
  static const String VOUCHER_PAYMENT = "charges?type=voucher_payment";
  static const String BANK_TRANSFER = "charges?type=bank_transfer";
  static const String PAY_WITH_ACCOUNT = "charges?type=debit_ng_account";
  static const String GET_BANKS_URL =
      "https://api.ravepay.co/flwv3-pug/getpaidx/api/flwpbf-banks.js?json=1";
  static const String PAY_WITH_MPESA = "charges?type=mpesa";

  static const String PAY_WITH_USSD = "charges?type=ussd";
  static const String RWANDA_MOBILE_MONEY = "charges?type=mobile_money_rwanda";
  static const String UGANDA_MOBILE_MONEY = "charges?type=mobile_money_uganda";
  static const String ZAMBIA_MOBILE_MONEY = "charges?type=mobile_money_zambia";
  static const String GHANA_MOBILE_MONEY = "charges?type=mobile_money_ghana";
  static const String FRANCOPHONE_MOBILE_MONEY =
      "charges?type=mobile_money_franco";

  static const String VALIDATE_CHARGE = "validate-charge";
  static const String VERIFY_TRANSACTION = "mpesa-verify";

  static const String DEFAULT_REDIRECT_URL = "https://flutterwave.com/ng/";

  static const String NGN = "NGN";
  static const String KES = "KES";
  static const String RWF = "RWF";
  static const String UGX = "UGX";
  static const String ZMW = "ZMW";
  static const String GHS = "GHS";
  static const String GBP = "GBP";
  static const String ZAR = "ZAR";
  static const String XAF = "XAF";
  static const String XOF = "XOF";

  static const String CHARGE_INITIATED = "Charge initiated";
  static const String PENDING = "pending";
  static const String CHARGE_VALIDATED = "Charge validated";
  static const String REQUIRES_AUTH = "Charge authorization data required";
  static const String SUCCESS = "success";
  static const String ERROR = "error";
  static const String SUCCESSFUL = "successful";
  static const String APPROVED_SUCCESSFULLY = "Approved successfully";
  static const String PENDING_OTP_VALIDATION = "Pending OTP validation";

  static String TripleDESEncrypt(dynamic data, String encryptionKey) {
    final blockCipher = BlockCipher(TripleDESEngine(), encryptionKey);
    return blockCipher.encodeB64(data);
  }

  static Map<String, String> encryptRequest(String encryptedData) {
    return {"client": encryptedData};
  }

  static String getBaseUrl(final bool isDebugMode) {
    return isDebugMode ? _DEBUG_BASE_URL : _PROD_BASE_URL;
  }

  static String getMobileMoneyUrl(final String currency) {
    switch (currency) {
      case UGX:
        return UGANDA_MOBILE_MONEY;
      case RWF:
        return RWANDA_MOBILE_MONEY;
      case ZMW:
        return ZAMBIA_MOBILE_MONEY;
      case GHS:
        return GHANA_MOBILE_MONEY;
      case XAF:
        return FRANCOPHONE_MOBILE_MONEY;
      case XOF:
        return FRANCOPHONE_MOBILE_MONEY;
    }
    return "";
  }

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
  }

  static List<FrancoPhoneCountry> getFrancoPhoneCountries(
      final String currency) {
    return [
      FrancoPhoneCountry("BURKINA FASO", "BF"),
      FrancoPhoneCountry("COTE D'IVOIRE", "CI"),
      FrancoPhoneCountry("GUINEA", "GN"),
      FrancoPhoneCountry("SENEGAL", "SN"),
      FrancoPhoneCountry("CAMEROON", "CM")
    ];
  }
}
