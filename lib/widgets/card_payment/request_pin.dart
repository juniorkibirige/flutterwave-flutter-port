import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';

class RequestPin extends StatefulWidget {
  final FlutterwavePaymentManager _paymentManager;

  RequestPin(this._paymentManager);

  @override
  _RequestPinState createState() => _RequestPinState();
}

class _RequestPinState extends State<RequestPin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              controller: this._pinController,
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
    return value.trim().isEmpty ? "Pin is required" : null;
  }

  void _continuePayment() {
    if (this._formKey.currentState.validate()) {
      //TODO
      print("Pin is ${this._pinController.value.text}");
//      this.widget._paymentManager.addPin(this._pinController.value.text);
      Navigator.of(this.context).pop(this._pinController.value.text);
    }
  }
}
