import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FlutterwavePaymentOption extends StatelessWidget {
  final Function handleClick;
  final String buttonText;

  FlutterwavePaymentOption({this.handleClick, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.handleClick,
      color: HexColor("#fff1d0"),
      child: Container(
        width: double.infinity,
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: "Pay with ",
            style: TextStyle(fontSize: 20, color: Colors.black),
            children: [
              TextSpan(
                text: buttonText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
