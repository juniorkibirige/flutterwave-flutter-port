class BankAccountPaymentRequest {
  String amount;
  String currency;
  String email;
  String fullName;
  String txRef;
  String phoneNumber;
  String accountBank;
  String accountNumber;

  BankAccountPaymentRequest(
      {this.amount,
      this.currency,
      this.email,
      this.fullName,
      this.txRef,
      this.phoneNumber,
      this.accountNumber,
      this.accountBank});

  BankAccountPaymentRequest.fromJson(Map<String, dynamic> json) {
    this.amount = json['amount'];
    this.currency = json['currency'];
    this.email = json['email'];
    this.txRef = json['tx_ref'];
    this.fullName = json["fullname"];
    this.phoneNumber = json["phone_number"];
    this.accountBank = json["account_bank"];
    this.accountNumber = json["account_number"];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'email': this.email,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'account_bank': this.accountBank,
      'account_number': this.accountNumber,
      'phone_number': this.phoneNumber
    };
  }
}
