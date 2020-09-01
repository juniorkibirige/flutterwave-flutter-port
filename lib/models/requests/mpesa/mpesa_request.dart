class MpesaRequest {
  String amount;
  String currency;
  String email;
  String txRef;
  String fullName;
  String phoneNumber;

  MpesaRequest({
    this.amount,
    this.currency,
    this.email,
    this.txRef,
    this.fullName,
    this.phoneNumber
  });

  MpesaRequest.fromJson(Map<String, dynamic> json) {
    this.amount = json['amount'];
    this.currency = json['currency'];
    this.email = json['email'];
    this.txRef = json['tx_ref'];
    this.fullName = json['fullname'];
    this.phoneNumber = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
      'email': this.email,
      'tx_ref': this.txRef,
      'fullname': this.fullName,
      'phone_number': this.phoneNumber
    };
  }
}

