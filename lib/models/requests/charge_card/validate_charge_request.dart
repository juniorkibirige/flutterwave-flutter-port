class ValidateChargeRequest {
  String otp;
  String flwRef;
  bool isBankAccount;

  ValidateChargeRequest(this.otp, this.flwRef, [this.isBankAccount = false]);

  ValidateChargeRequest.fromJson(Map<String, dynamic> json) {
    this.otp = json["otp"];
    this.flwRef = json["flw_ref"];
    if(json["type"] != null) {
      this.isBankAccount = json["type"];
    } else {
      this.isBankAccount = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["otp"] = this.otp;
    data["flw_ref"] = this.flwRef;
    if (this.isBankAccount) {
      data["type"] = "account";
    }
    return data;
  }
}
