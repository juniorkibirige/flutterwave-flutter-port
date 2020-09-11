import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwave/core/utils/flutterwave_api_utils.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/core/bank_transfer_manager/bank_transfer_payment_manager.dart';
import 'package:flutterwave/models/requests/bank_transfer/bank_transfer_request.dart';
import 'package:flutterwave/models/responses/bank_transfer_response/bank_transfer_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:hexcolor/hexcolor.dart';

import 'pay_with_account_button.dart';
import 'show_transfer_details.dart';

class BankTransfer extends StatefulWidget {
  final BankTransferPaymentManager _paymentManager;

  BankTransfer(this._paymentManager);

  @override
  _BankTransferState createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext loadingDialogContext;

  BankTransferResponse _bankTransferResponse;
  bool hasInitiatedPay = false;
  bool hasVerifiedPay = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          key: this._scaffoldKey,
          appBar: AppBar(
            backgroundColor: Hexcolor("#fff1d0"),
            title: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Pay with ",
                style: TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  TextSpan(
                    text: "Bank Transfer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  width: double.infinity,
                  child: this._getHomeView()))),
    );
  }

  Widget _getHomeView() {
    return this.hasInitiatedPay
        ? AccountDetails(this._bankTransferResponse, this._verifyTransfer)
        : PayWithTransferButton(this._initiateBankTransfer);
  }

  void _initiateBankTransfer() async {
    this.showLoading("initiating payment...");
    final http.Client client = http.Client();
    final BankTransferRequest request = BankTransferRequest(
        amount: this.widget._paymentManager.amount,
        currency: this.widget._paymentManager.currency,
        duration: this.widget._paymentManager.duration.toString(),
        email: this.widget._paymentManager.email,
        frequency: this.widget._paymentManager.frequency.toString(),
        isPermanent: this.widget._paymentManager.isPermanent.toString(),
        narration: this.widget._paymentManager.narration,
        phoneNumber: this.widget._paymentManager.phoneNumber,
        txRef: this.widget._paymentManager.txRef);

    try {
      final BankTransferResponse response = await this
          .widget
          ._paymentManager
          .payWithBankTransfer(request, client);
      if (FlutterwaveUtils.SUCCESS == response.status) {
        print("Trabsfer response is ${response.toJson()}");
        this._afterChargeInitiated(response);
      } else {
        this.closeDialog();
        this.showSnackBar(response.message);
      }
    } catch (error) {
      this.showSnackBar(error.toString());
    } finally {
      this.closeDialog();
    }
  }

  void _verifyTransfer() async {
    if (this._bankTransferResponse != null) {
      final timeoutInMinutes = 2;
      final timeOutInSeconds = timeoutInMinutes * 60;
      final requestIntervalInSeconds = 15;
      final numberOfTries = timeOutInSeconds / requestIntervalInSeconds;
      int intialCount = 0;

      this.showLoading("verifying payment...");
      Timer.periodic(Duration(seconds: requestIntervalInSeconds),
          (timer) async {
        final client = http.Client();
        print("Initial count is is => $intialCount");
        print("number of tries is => $numberOfTries");
        if (intialCount >= numberOfTries) {
          timer.cancel();
          this.closeDialog();
        }
        try {
//          final response = await this.widget._paymentManager.verifyPayment(
//              this._bankTransferResponse.meta.authorization.transferReference,
//              client);
          final response = await FlutterwaveAPIUtils.verifyPayment(
              this._bankTransferResponse.meta.authorization.transferReference,
              client,
              this.widget._paymentManager.publicKey,
              this.widget._paymentManager.isDebugMode);
          
          print("tranfer ref is ${ this._bankTransferResponse.meta.authorization.transferReference}");
          print("flw_ref is => ${response.data.flwRef}");

          print("response status is => ${response.data.status}");

          if (response.data.status == FlutterwaveUtils.SUCCESS &&
              response.data.flwRef ==
                  this
                      ._bankTransferResponse
                      .meta
                      .authorization
                      .transferReference
                      .toString()) {
            this.closeDialog();
            this.showSnackBar("Payment received");
            timer.cancel();
            this.onPaymentComplete(response);
          } else {
            print("inside else, response is ${response.toJson()}");
            this.showSnackBar(response.message);
          }
        } catch (error) {
          timer.cancel();
          this.closeDialog();
          this.showSnackBar(error.toString());
        } finally {
          intialCount = intialCount + 1;
        }
      });
    } else {
      this.showSnackBar("An unexpected error ocurred.");
    }
  }

  void _afterChargeInitiated(BankTransferResponse response) {
    this.setState(() {
      this._bankTransferResponse = response;
      this.hasInitiatedPay = true;
    });
  }

  void showSnackBar(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    this._scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void onPaymentComplete(final ChargeResponse chargeResponse) {
    this.showSnackBar("Transaction completed.");
    Navigator.pop(this.context, chargeResponse);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        this.loadingDialogContext = context;
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        );
      },
    );
  }

  void closeDialog() {
    if (this.loadingDialogContext != null) {
      Navigator.of(this.loadingDialogContext).pop();
      this.loadingDialogContext = null;
    }
  }
}
