import 'package:flutterwave/models/requests/authorization.dart';

import 'charge_card_response_data.dart';

class ChargeCardResponse {
  String status;
  String message;
  ChargeCardResponseData data;
  Meta meta;

  ChargeCardResponse({this.status, this.message, this.data, this.meta});

  ChargeCardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ChargeCardResponseData.fromJson(json['data']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}


class Meta {
  Authorization authorization;

  Meta({this.authorization});

  Meta.fromJson(Map<String, dynamic> json) {
    authorization = json['authorization'] != null ? new Authorization.fromJson(json['authorization']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.authorization != null) {
      data['authorization'] = this.authorization.toJson();
    }
    return data;
  }
}

