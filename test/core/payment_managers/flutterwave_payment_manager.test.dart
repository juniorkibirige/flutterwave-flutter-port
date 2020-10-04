import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwave/core/bank_transfer_manager/bank_transfer_payment_manager.dart';
import 'package:flutterwave/core/card_payment_manager/card_payment_manager.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';
import 'package:flutterwave/core/mobile_money/mobile_money_payment_manager.dart';
import 'package:flutterwave/core/mpesa/mpesa_payment_manager.dart';
import 'package:flutterwave/core/ussd_payment_manager/ussd_manager.dart';
import 'package:flutterwave/core/voucher_payment/voucher_payment_manager.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';

main() {
  group("Flutterwave Payment Manager", () {
    final String pbKey = "pbKey";
    final String enKey = "enKey";
    final String currency = FlutterwaveCurrency.RWF;
    final String email = "email";
    final String amount = "100";
    final String txRef = "txRef";
    final String fullName = "Full Name";
    final String phoneNumber = "12344";
    final bool isDebugMode = true;

    final paymentManager = FlutterwavePaymentManager(
        publicKey: pbKey,
        encryptionKey: enKey,
        currency: currency,
        amount: amount,
        email: email,
        fullName: fullName,
        txRef: txRef,
        isDebugMode: isDebugMode,
        phoneNumber: phoneNumber);

    test("should be instantiated correctly", () {
      expect(FlutterwavePaymentManager, paymentManager.runtimeType);
      expect(paymentManager.amount, amount);
      expect(paymentManager.currency, currency);
      expect(paymentManager.txRef, txRef);
      expect(paymentManager.isDebugMode, isDebugMode);
      expect(paymentManager.publicKey, pbKey);

    });

    test("should return CardPaymentManager", () {
      final cardPaymentManager = paymentManager.getCardPaymentManager();
      expect(CardPaymentManager, cardPaymentManager.runtimeType);
      expect(cardPaymentManager.amount, paymentManager.amount);
      expect(cardPaymentManager.currency, paymentManager.currency);
      expect(cardPaymentManager.txRef, paymentManager.txRef);
      expect(cardPaymentManager.isDebugMode, paymentManager.isDebugMode);
      expect(cardPaymentManager.publicKey, paymentManager.publicKey);

    });

    test("should return BankTransferPaymentManager", () {
      final bankTransferPM = paymentManager.getBankTransferPaymentManager();
      expect(BankTransferPaymentManager, bankTransferPM.runtimeType);
      expect(bankTransferPM.amount, paymentManager.amount);
      expect(bankTransferPM.currency, paymentManager.currency);
      expect(bankTransferPM.txRef, paymentManager.txRef);
      expect(bankTransferPM.isDebugMode, paymentManager.isDebugMode);
      expect(bankTransferPM.publicKey, paymentManager.publicKey);

    });

    test("should return USSDPaymentManager", () {
      final ussdPM = paymentManager.getUSSDPaymentManager();
      expect(USSDPaymentManager, ussdPM.runtimeType);
      expect(paymentManager.amount, ussdPM.amount);
      expect(paymentManager.currency, ussdPM.currency);
      expect(paymentManager.txRef, ussdPM.txRef);
      expect(paymentManager.isDebugMode, ussdPM.isDebugMode);
      expect(paymentManager.publicKey, ussdPM.publicKey);
    });

    test("should return MobileMoneyPaymentManager", () {
      final mobileMoneyPM = paymentManager.getMobileMoneyPaymentManager();
      expect(MobileMoneyPaymentManager, mobileMoneyPM.runtimeType);
      expect(paymentManager.amount, mobileMoneyPM.amount);
      expect(paymentManager.currency, mobileMoneyPM.currency);
      expect(paymentManager.txRef, mobileMoneyPM.txRef);
      expect(paymentManager.isDebugMode, mobileMoneyPM.isDebugMode);
      expect(paymentManager.publicKey, mobileMoneyPM.publicKey);

    });

    test("should return MpesaPaymentManager", () {
      final mpesaPM = paymentManager.getMpesaPaymentManager();
      expect(MpesaPaymentManager, mpesaPM.runtimeType);
      expect(paymentManager.amount, mpesaPM.amount);
      expect(paymentManager.currency, mpesaPM.currency);
      expect(paymentManager.txRef, mpesaPM.txRef);
      expect(paymentManager.isDebugMode, mpesaPM.isDebugMode);
      expect(paymentManager.publicKey, mpesaPM.publicKey);

    });

    test("should return VoucherPaymentManager", () {
      final voucherPM = paymentManager.getVoucherPaymentManager();
      expect(VoucherPaymentManager, voucherPM.runtimeType);
      expect(paymentManager.amount, voucherPM.amount);
      expect(paymentManager.currency, voucherPM.currency);
      expect(paymentManager.txRef, voucherPM.txRef);
      expect(paymentManager.isDebugMode, voucherPM.isDebugMode);
      expect(paymentManager.publicKey, voucherPM.publicKey);
    });
  });
}
