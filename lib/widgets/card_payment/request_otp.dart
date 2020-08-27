import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';

class RequestOTP extends StatefulWidget {
  final String descriptionText;

  RequestOTP(this.descriptionText);

  @override
  _RequestOTPState createState() => _RequestOTPState();
}

class _RequestOTPState extends State<RequestOTP> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            this.widget.descriptionText,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Pin",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              obscureText: true,
              autocorrect: false,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
              controller: this._otpController,
              validator: this._pinValidator,
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: this._continuePayment,
              color: Colors.orangeAccent,
              child: Text(
                "CONTINUE PAYMENT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _pinValidator(String value) {
    return value.trim().isEmpty ? "Otp is required" : null;
  }

  void _continuePayment() {
    if (this._formKey.currentState.validate()) {
      print("Pin is ${this._otpController.value.text}");
      Navigator.of(this.context).pop(this._otpController.value.text);
    }
  }
}
