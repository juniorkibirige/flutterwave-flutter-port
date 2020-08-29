import 'package:flutterwave/models/responses/charge_card_response/charge_card_response_card.dart';
import 'package:flutterwave/models/responses/charge_card_response/charge_card_response_customer.dart';

class ChargeResponseData {
  String id;
  String txRef;
  String flwRef;
  String deviceFingerprint;
  String amount;
  String chargedAmount;
  String appFee;
  String merchantFee;
  String processorResponse;
  String authModel;
  String currency;
  String ip;
  String narration;
  String status;
  String authUrl;
  String paymentType;
  String fraudStatus;
  String chargeType;
  String createdAt;
  String accountId;
  ChargeCardResponseCustomer customer;
  ChargeCardResponseCard card;

  ChargeResponseData(
      {this.id,
        this.txRef,
        this.flwRef,
        this.deviceFingerprint,
        this.amount,
        this.chargedAmount,
        this.appFee,
        this.merchantFee,
        this.processorResponse,
        this.authModel,
        this.currency,
        this.ip,
        this.narration,
        this.status,
        this.authUrl,
        this.paymentType,
        this.fraudStatus,
        this.chargeType,
        this.createdAt,
        this.accountId,
        this.customer,
        this.card});

  ChargeResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    txRef = json['tx_ref'];
    flwRef = json['flw_ref'];
    deviceFingerprint = json['device_fingerprint'];
    amount = json['amount'].toString();
    chargedAmount = json['charged_amount'].toString();
    appFee = json['app_fee'].toString();
    merchantFee = json['merchant_fee'].toString();
    processorResponse = json['processor_response'];
    authModel = json['auth_model'];
    currency = json['currency'];
    ip = json['ip'];
    narration = json['narration'];
    status = json['status'];
    authUrl = json['auth_url'];
    paymentType = json['payment_type'];
    fraudStatus = json['fraud_status'];
    chargeType = json['charge_type'];
    createdAt = json['created_at'];
    accountId = json['account_id'].toString();
    customer = json['customer'] != null ? new ChargeCardResponseCustomer.fromJson(json['customer']) : null;
    card = json['card'] != null ? new ChargeCardResponseCard.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tx_ref'] = this.txRef;
    data['flw_ref'] = this.flwRef;
    data['device_fingerprint'] = this.deviceFingerprint;
    data['amount'] = this.amount;
    data['charged_amount'] = this.chargedAmount;
    data['app_fee'] = this.appFee;
    data['merchant_fee'] = this.merchantFee;
    data['processor_response'] = this.processorResponse;
    data['auth_model'] = this.authModel;
    data['currency'] = this.currency;
    data['ip'] = this.ip;
    data['narration'] = this.narration;
    data['status'] = this.status;
    data['auth_url'] = this.authUrl;
    data['payment_type'] = this.paymentType;
    data['fraud_status'] = this.fraudStatus;
    data['charge_type'] = this.chargeType;
    data['created_at'] = this.createdAt;
    data['account_id'] = this.accountId;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}