import 'package:flutterwave/models/bank.dart';

class GetBanksResponse {
  String? status;
  String? message;
  List<Bank>? banks;

  GetBanksResponse({this.status, this.message,this.banks});

  // GetBanksResponse.fromJson(Map<String, dynamic> json) {
  //   bankname = json['bankname'];
  //   bankcode = json['bankcode'];
  //   internetbanking = json['internetbanking'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['bankname'] = this.bankname;
  //   data['bankcode'] = this.bankcode;
  //   data['internetbanking'] = this.internetbanking;
  //   return data;
  // }

  GetBanksResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    banks = json["data"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.banks;
    return data;
  }
}