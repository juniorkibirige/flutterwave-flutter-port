class GetBanksResponse {
  String bankname;
  String bankcode;
  bool internetbanking;

  GetBanksResponse({this.bankname, this.bankcode, this.internetbanking});

  GetBanksResponse.fromJson(Map<String, dynamic> json) {
    bankname = json['bankname'];
    bankcode = json['bankcode'];
    internetbanking = json['internetbanking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankname'] = this.bankname;
    data['bankcode'] = this.bankcode;
    data['internetbanking'] = this.internetbanking;
    return data;
  }
}