class USSDRequest {
  String amount;
  String currency;
  String email;
  String txRef;
  String fullName;
  String accountBank;
  String phoneNumber;

  USSDRequest({
    this.amount,
    this.currency,
    this.email,
    this.txRef,
    this.fullName,
    this.accountBank,
    this.phoneNumber
  });

  USSDRequest.fromJson(Map<String, dynamic> json) {
    this.amount = json['amount'];
    this.currency = json['currency'];
    this.email = json['email'];
    this.txRef = json['tx_ref'];
    this.fullName = json['fullname'];
    this.accountBank = json['account_bank'];
    this.phoneNumber = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'email': this.email,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'account_bank': this.accountBank,
      'phone_number': this.phoneNumber
    };
  }
}