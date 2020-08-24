class Authorization {
  static const String PIN = "pin";
  static const String AVS = "avs_noauth";
  static const String OTP = "otp";

  String mode;
  String pin;
  String endpoint;
  List<dynamic> fields;

  Authorization({this.mode, this.endpoint});


  Authorization.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    endpoint = json['endpoint'];
    this.fields = json["fields"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["mode"] = this.mode;
    data["endpoint"] = this.endpoint;
    data["fields"] = this.fields;
    return data;
  }

}