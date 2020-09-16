import 'package:flutter/material.dart';
import 'package:flutterwave/core/pay_with_account_manager/bank_account_manager.dart';
import 'package:flutterwave/models/requests/authorization.dart';
import 'package:flutterwave/models/requests/pay_with_bank_account/pay_with_bank_account.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:flutterwave/widgets/card_payment/authorization_webview.dart';
import 'package:flutterwave/widgets/card_payment/request_otp.dart';
import 'package:flutterwave/widgets/flutterwave_view_utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutterwave/core/utils/flutterwave_api_utils.dart';
import 'package:flutterwave/models/responses/get_bank/get_bank_response.dart';
import 'package:hexcolor/hexcolor.dart';

class RequestBankAccount extends StatefulWidget {
  final BankAccountPaymentManager _paymentManager;

  RequestBankAccount(this._paymentManager);

  @override
  RequestBankAccountState createState() => RequestBankAccountState();
}

class RequestBankAccountState extends State<RequestBankAccount> {
  GetBanksResponse selectedBank;
  PersistentBottomSheetController bottomSheet;
  Future<List<GetBanksResponse>> banks;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  FocusNode _bankFocusNode = new FocusNode();

  BuildContext _loadingDialogContext;

  @override
  void initState() {
    super.initState();
    this.banks = FlutterwaveAPIUtils.getBanks(http.Client());
    this._bankFocusNode.addListener(() {
      if (this._bankFocusNode.hasFocus) {
        this._showBottomSheet();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._accountNumberController.dispose();
    this._phoneNumberController.dispose();
    this._bankController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget._paymentManager.phoneNumber);
    this._phoneNumberController.text = this.widget._paymentManager.phoneNumber;
    this._bankController.text =
        this.selectedBank != null ? this.selectedBank.bankname : "";
    return MaterialApp(
      home: Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          backgroundColor: Hexcolor("#fff1d0"),
          title: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: "Pay with ",
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(
                  text: "Account",
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
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Form(
              key: this._formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      labelText: "Phone Number",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    controller: this._phoneNumberController,
                    validator: (value) =>
                        value.isEmpty ? "Phone Number is required" : null,
                  ),
                  TextFormField(
                    focusNode: this._bankFocusNode,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Bank",
                      labelText: "Bank",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    controller: this._bankController,
                    validator: (value) =>
                        value.isEmpty ? "Bank is required" : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Account Number",
                      labelText: "Account Number",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    controller: this._accountNumberController,
                    validator: (value) =>
                        value.isEmpty ? "Account Number is required" : null,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: RaisedButton(
                      onPressed: this._onPaymentClicked,
                      color: Colors.orangeAccent,
                      child: Text(
                        "PAY WITH ACCOUNT",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _banks() {
    return FutureBuilder(
        future: this.banks,
        builder: (BuildContext context,
            AsyncSnapshot<List<GetBanksResponse>> snapshot) {
          if (snapshot.hasData) {
            return this._bankLists(snapshot.data);
          }
          if (snapshot.hasError) {
            return Center(child: Text("Unable to fetch banks."));
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _bankLists(final List<GetBanksResponse> banks) {
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: banks
            .map((bank) => ListTile(
                  onTap: () => {this._handleBankTap(bank)},
                  title: Column(
                    children: [
                      Text(
                        bank.bankname,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 4),
                      Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _onPaymentClicked() {
    if (this._formKey.currentState.validate()) {
      final BankAccountPaymentManager pm = this.widget._paymentManager;
      FlutterwaveViewUtils.showConfirmPaymentModal(
          this.context, pm.currency, pm.amount, this._payWithBankAccount);
    }
  }

  void _payWithBankAccount() async {
    Navigator.pop(this.context);

    this.showLoading("initiating payment...");

    final BankAccountPaymentRequest request = BankAccountPaymentRequest(
        amount: this.widget._paymentManager.amount,
        currency: this.widget._paymentManager.currency,
        email: this.widget._paymentManager.email,
        fullName: this.widget._paymentManager.fullName,
        txRef: this.widget._paymentManager.txRef,
        phoneNumber: this._phoneNumberController.text.trim(),
        accountBank: this.selectedBank.bankcode,
        accountNumber: this._accountNumberController.text.trim());

    final response = await this
        .widget
        ._paymentManager
        .payWithAccount(request, http.Client());

    print("Error paying with account is ${response.toJson()}");

    this.closeDialog();
    if (response.data == null || response.status == FlutterwaveUtils.ERROR) {
      this.showSnackBar(response.message);
      return;
    }
    if (response.data.processorResponse ==
            FlutterwaveUtils.PENDING_OTP_VALIDATION ||
        (response.meta != null &&
            response.meta.authorization != null &&
            response.data.status == FlutterwaveUtils.PENDING)) {
      if (response.data.processorResponse == FlutterwaveUtils.PENDING) {
        this._handleExtraAuthentication(response);
      } else {
        this.showSnackBar(
            "Unable to continue payment with card authentication mode ${response.meta.authorization.mode}");
      }
      return;
    }
    if (response.data.status == FlutterwaveUtils.SUCCESSFUL &&
        response.data.processorResponse ==
            FlutterwaveUtils.APPROVED_SUCCESSFULLY) {
      this._verifyPayment(response);
    } else {
      this.closeDialog();
      this.showSnackBar(response.message);
    }
  }

  void _handleExtraAuthentication(ChargeResponse response) async {
    if (response.meta != null &&
        response.meta.authorization != null &&
        response.meta.authorization.mode != null) {
      final String authMode = response.meta.authorization.mode;
      switch (authMode) {
        case Authorization.OTP:
          {
            this._handleOtp(response);
            break;
          }
        case Authorization.REDIRECT:
          {
            this.handleRedirect(response);
            break;
          }
      }
    } else {
      this.closeDialog();
      this.showSnackBar("Unable to continue payment");
    }
  }

  void _verifyPayment(ChargeResponse chargeResponse) async {
    this.showLoading("verifying payment...");
    final response = await FlutterwaveAPIUtils.verifyPayment(
        chargeResponse.data.flwRef,
        http.Client(),
        this.widget._paymentManager.publicKey,
        this.widget._paymentManager.isDebugMode);

    this.closeDialog();

    if (response.status == FlutterwaveUtils.ERROR || response.data == null) {
      this.showSnackBar(response.message);
      this._onPaymentComplete(response);
      return;
    }
    if (response.status == FlutterwaveUtils.SUCCESS &&
        response.data.amount == this.widget._paymentManager.amount &&
        response.data.txRef == this.widget._paymentManager.txRef) {
      this._onPaymentComplete(response);
      return;
    }
    this._onPaymentComplete(response);
    this.showSnackBar(response.message);
    return;
  }

  void _handleOtp(final ChargeResponse response) async {
    this.closeDialog();
    String message;
    if (response.meta != null &&
        response.meta.authorization != null &&
        response.meta.authorization.validateInstructions != null) {
      message = response.meta.authorization.validateInstructions;
    } else {
      message = "Please validate with the OTP sent to your mobile or email";
    }
    final otp = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RequestOTP(message)));
    if (otp == null) {
      this.showSnackBar("Transaction cancelled.");
      return;
    }
    this._validatePayment(otp, response.data.flwRef);
  }

  void handleRedirect(ChargeResponse response) async {
    this.closeDialog();
    final String url = response.meta.authorization.redirect;
    if (url == null || url.isEmpty) {
      this.showSnackBar("Unable to redirect to complete payment.");
      return;
    }
    final flw = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AuthorizationWebview(Uri.encodeFull(url))));
    if (response == null) {
      this.showSnackBar("Transaction cancelled.");
      return;
    }
    this._verifyPayment(flw);
  }

  void _validatePayment(final String otp, final String flwRef) async {
    this.showLoading("validating otp...");
    final client = http.Client();
    final response = await FlutterwaveAPIUtils.validatePayment(
        otp,
        flwRef,
        client,
        this.widget._paymentManager.isDebugMode,
        this.widget._paymentManager.publicKey);
    this.closeDialog();
    if (response.status == FlutterwaveUtils.SUCCESS &&
        response.message == FlutterwaveUtils.CHARGE_VALIDATED) {
      this._verifyPayment(response);
    } else {
      print("response in validating is => ${response.toJson()}");
      this.showSnackBar(response.message);
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: this.context,
      builder: (context) {
        return this._banks();
      },
    );
  }

  void _handleBankTap(final GetBanksResponse selectedBank) {
    this._removeFocusFromView();
    this.setState(() {
      this.selectedBank = selectedBank;
    });
    Navigator.pop(this.context);
  }

  void _removeFocusFromView() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  void showSnackBar(String message) {
    final text = message == null
        ? "Unable to complete payment. Please contact support"
        : message;
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
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
        this._loadingDialogContext = context;
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
    if (this._loadingDialogContext != null) {
      Navigator.of(this._loadingDialogContext).pop();
      this._loadingDialogContext = null;
    }
  }

  void _onPaymentComplete(final ChargeResponse chargeResponse) {
    this.showSnackBar("Transaction complete!");
    Navigator.pop(this.context, chargeResponse);
  }
}
