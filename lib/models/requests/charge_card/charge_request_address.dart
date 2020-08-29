class ChargeRequestAddress {
  String address;
  String city;
  String state;
  String zipCode;
  String country;

  ChargeRequestAddress({
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  ChargeRequestAddress.fromJson(Map<String, dynamic> json) {
    this.address = json["address"];
    this.city = json["city"];
    this.state = json["state"];
    this.zipCode = json["zipcode"];
    this.country = json["country"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["address"] = this.address;
    data["city"] = this.city;
    data["state"] = this.state;
    data["zipcode"] = this.zipCode;
    data["country"] = this.country;
    return data;
  }
}
