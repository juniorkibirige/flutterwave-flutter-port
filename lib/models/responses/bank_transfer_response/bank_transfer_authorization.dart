class BankTransferAuthorization {
  String transferReference = "";
  String transferAccount = "";
  String transferBank = "";
  String accountExpiration = "";
  String transferNote = "";
  int transferAmount = 0;
  String mode = "";

  BankTransferAuthorization(
      {required this.transferReference,
      required this.transferAccount,
      required this.transferBank,
      required this.accountExpiration,
      required this.transferNote,
      required this.transferAmount,
      required this.mode});

  BankTransferAuthorization.fromJson(Map<String, dynamic> json) {
    transferReference = json['transfer_reference'];
    transferAccount = json['transfer_account'];
    transferBank = json['transfer_bank'];
    accountExpiration = json['account_expiration'];
    transferNote = json['transfer_note'];
    transferAmount = json['transfer_amount'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transfer_reference'] = this.transferReference;
    data['transfer_account'] = this.transferAccount;
    data['transfer_bank'] = this.transferBank;
    data['account_expiration'] = this.accountExpiration;
    data['transfer_note'] = this.transferNote;
    data['transfer_amount'] = this.transferAmount;
    data['mode'] = this.mode;
    return data;
  }
}
