import 'package:flutter/material.dart';
import 'package:flutterwave/core/card_payment_manager/card_payment_manager.dart';
import 'package:flutterwave/core/core_utils/flutterwave_api_utils.dart';
import 'package:flutterwave/interfaces/card_payment_listener.dart';
import 'package:flutterwave/models/requests/charge_card/charge_card_request.dart';
import 'package:flutterwave/models/requests/charge_card/charge_request_address.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/widgets/card_payment/authorization_webview.dart';
import 'package:flutterwave/widgets/card_payment/request_address.dart';
import 'package:flutterwave/widgets/flutterwave_view_utils.dart';
import 'package:http/http.dart' as http;

import 'request_otp.dart';
import 'request_pin.dart';

class CardPayment extends StatefulWidget {
  final CardPaymentManager _paymentManager;

  CardPayment(this._paymentManager);

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment>
    implements CardPaymentListener {
  final _cardFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BuildContext loadingDialogContext;

  final TextEditingController _cardNumberFieldController =
      TextEditingController();
  final TextEditingController _cardMonthFieldController =
      TextEditingController();
  final TextEditingController _cardYearFieldController =
      TextEditingController();
  final TextEditingController _cardCvvFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    this._cardMonthFieldController.dispose();
    this._cardYearFieldController.dispose();
    this._cardCvvFieldController.dispose();
    this._cardNumberFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: this._scaffoldKey,
        body: Form(
          key: this._cardFormKey,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  child: Text(
                    "Enter your card details",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Card Number",
                      labelText: "Card Number",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    controller: this._cardNumberFieldController,
                    validator: this._validateCardField,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Month",
                          labelText: "Month",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: this._cardMonthFieldController,
                        validator: this._validateCardField,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Year",
                          labelText: "Year",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: this._cardYearFieldController,
                        validator: this._validateCardField,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "cvv",
                          labelText: "cvv",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        autocorrect: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: this._cardCvvFieldController,
                        validator: (value) =>
                            value.isEmpty ? "cvv is required" : null,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: RaisedButton(
                    onPressed: this._onCardFormClick,
                    color: Colors.orangeAccent,
                    child: Text(
                      "PAY",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.black26,
                  margin: EdgeInsets.fromLTRB(25, 1, 25, 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCardFormClick() {
    this._hideKeyboard();
    if (this._cardFormKey.currentState.validate()) {
      final CardPaymentManager pm = this.widget._paymentManager;
      FlutterwaveViewUtils.showConfirmPaymentModal(
          this.context, pm.currency, pm.amount, this._makeCardPayment);
    }
  }

  void _makeCardPayment() {
    Navigator.of(this.context).pop();
    this.showLoading(FlutterwaveConstants.INITIATING_PAYMENT);
    final ChargeCardRequest chargeCardRequest = ChargeCardRequest(
        cardNumber: this._cardNumberFieldController.value.text.trim(),
        cvv: this._cardCvvFieldController.value.text.trim(),
        expiryMonth: this._cardMonthFieldController.value.text.trim(),
        expiryYear: this._cardYearFieldController.value.text.trim(),
        currency: this.widget._paymentManager.currency.trim(),
        amount: this.widget._paymentManager.amount.trim(),
        email: this.widget._paymentManager.email.trim(),
        fullName: this.widget._paymentManager.fullName.trim(),
        txRef: this.widget._paymentManager.txRef.trim(),
        country: this.widget._paymentManager.country);
    final client = http.Client();
    this
        .widget
        ._paymentManager
        .setCardPaymentListener(this)
        .payWithCard(client, chargeCardRequest);
  }

  Future<void> showConfirmPaymentModal() async {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Text(
              "You will be charged a total of ${this.widget._paymentManager.currency}"
              "${this.widget._paymentManager.amount}. Do you wish to continue? ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
          ),
          actions: [
            FlatButton(
              onPressed: this._makeCardPayment,
              child: Text(
                "CONTINUE",
                style: TextStyle(fontSize: 16, letterSpacing: 1),
              ),
            ),
            FlatButton(
              onPressed: () => {Navigator.of(this.context).pop()},
              child: Text(
                "CANCEL",
                style: TextStyle(fontSize: 16, letterSpacing: 1),
              ),
            )
          ],
        );
      },
    );
  }

  String _validateCardField(String value) {
    return value.trim().isEmpty ? "Please fill this" : null;
  }

  void _hideKeyboard() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  @override
  void onRedirect(ChargeResponse chargeResponse, String url) async {
    this.closeDialog();
    final result = await Navigator.of(this.context).push(MaterialPageRoute(
        builder: (context) => AuthorizationWebview(Uri.encodeFull(url))));
    if (result != null) {
      print("result in webview issss $result");
      final bool hasError = result.runtimeType != " ".runtimeType;
      this.closeDialog();
      if (hasError) {
        this.showSnackBar(result["error"]);
        return;
      }
      final flwRef = result;
      this.showLoading(FlutterwaveConstants.VERIFYING);
      final response = await FlutterwaveAPIUtils.verifyPayment(
          flwRef,
          http.Client(),
          this.widget._paymentManager.publicKey,
          this.widget._paymentManager.isDebugMode);
      this.closeDialog();
      if (response.data.status == FlutterwaveConstants.SUCCESSFUL) {
        this.onComplete(response);
      }
    } else {
      this.showSnackBar("Transaction cancelled");
    }
  }

  @override
  void onRequireAddress(ChargeResponse response) async {
    this.closeDialog();
    final ChargeRequestAddress addressDetails = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RequestAddress()));
    if (addressDetails != null) {
      this.showLoading(FlutterwaveConstants.VERIFYING_ADDRESS);
      this.widget._paymentManager.addAddress(addressDetails);
      return;
    }
    this.closeDialog();
  }

  @override
  void onRequirePin(ChargeResponse response) async {
    this.closeDialog();
    final pin = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RequestPin()));
    if (pin == null) return;
    this.showLoading(FlutterwaveConstants.AUTHENTICATING_PIN);
    this.widget._paymentManager.addPin(pin);
  }

  @override
  void onRequireOTP(ChargeResponse response, String message) async {
    this.closeDialog();
    final otp = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RequestOTP(message)));
    if (otp == null) return;
    this.showLoading(FlutterwaveConstants.VERIFYING);
    final ChargeResponse chargeResponse =
        await this.widget._paymentManager.addOTP(otp, response.data.flwRef);
    this.closeDialog();
    if (chargeResponse.message == FlutterwaveConstants.CHARGE_VALIDATED) {
      this.showLoading(FlutterwaveConstants.VERIFYING);
      this._handleTransactionVerification(chargeResponse);
    } else {
      this.closeDialog();
      this.showSnackBar(chargeResponse.message);
    }
  }

  void _handleTransactionVerification(
      final ChargeResponse chargeResponse) async {
    final verifyResponse = await FlutterwaveAPIUtils.verifyPayment(
        chargeResponse.data.flwRef,
        http.Client(),
        this.widget._paymentManager.publicKey,
        this.widget._paymentManager.isDebugMode);
    this.closeDialog();

    if (verifyResponse.status == FlutterwaveConstants.SUCCESS &&
        verifyResponse.data.txRef == this.widget._paymentManager.txRef &&
        verifyResponse.data.amount == this.widget._paymentManager.amount) {
      this.onComplete(verifyResponse);
    } else {
      this.showSnackBar(verifyResponse.message);
    }
  }

  @override
  void onError(String error) {
    this.closeDialog();
    this.showSnackBar(error);
  }

  @override
  void onComplete(ChargeResponse chargeResponse) {
    Navigator.pop(this.context, chargeResponse);
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
