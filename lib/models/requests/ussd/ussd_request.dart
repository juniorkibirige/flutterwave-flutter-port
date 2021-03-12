class USSDRequest {
  String amount;
  String currency;
  String email;
  String txRef;
  String fullName;
  String accountBank;
  String phoneNumber;

  USSDRequest({
    required this.amount,
    required this.currency,
    required this.email,
    required this.txRef,
    required this.fullName,
    required this.accountBank,
    required this.phoneNumber
  });

  /// Converts instance of USSDRequest to json
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