class ValidateChargeRequest {
  String otp;
  String flwRef;

  ValidateChargeRequest(this.otp, this.flwRef);

  ValidateChargeRequest.fromJson(Map<String, dynamic> json) {
    this.otp = json["otp"];
    this.flwRef = json["flw_ref"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["otp"] = this.otp;
    data["flw_ref"] = this.flwRef;
    return data;
  }
}
