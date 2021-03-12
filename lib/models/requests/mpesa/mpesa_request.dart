class MpesaRequest {
  String amount;
  String currency;
  String email;
  String txRef;
  String fullName;
  String phoneNumber;

  MpesaRequest({
    required this.amount,
    required this.currency,
    required this.email,
    required this.txRef,
    required this.fullName,
    required this.phoneNumber
  });

/// Converts instance of MpesaRequest to json
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

