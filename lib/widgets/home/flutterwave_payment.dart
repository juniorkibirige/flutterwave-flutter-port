import 'package:flutter/material.dart';
import 'package:flutterwave/core/bank_transfer_manager/bank_transfer_payment_manager.dart';
import 'package:flutterwave/core/card_payment_manager/card_payment_manager.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';
import 'package:flutterwave/widgets/bank_transfer/bank_transfer_payment.dart';
import 'package:flutterwave/widgets/card_payment/card_payment.dart';

import 'flutterwave_payment_option.dart';

class FlutterwaveUI extends StatefulWidget {
  final FlutterwavePaymentManager _flutterwavePaymentManager;

  FlutterwaveUI(this._flutterwavePaymentManager);

  @override
  _FlutterwaveUIState createState() => _FlutterwaveUIState();
}

class _FlutterwaveUIState extends State<FlutterwaveUI> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 10.0,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "SECURED BY FLUTTERWAVE",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0,
                              letterSpacing: 1.0),
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 150.0,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.zero,
                      child: Text(
                        "How would you \nlike to pay?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 150.0,
              ),
              Container(
                color: Colors.white38,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: FlutterwavePaymentOption(
                        handleClick: () => {},
                        buttonText: "Account",
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: FlutterwavePaymentOption(
                        handleClick: this._launchCardPaymentWidget,
                        buttonText: "Card",
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: FlutterwavePaymentOption(
                        handleClick: this._launchBankTransferPaymentWidget,
                        buttonText: "Bank Transfer",
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: FlutterwavePaymentOption(
                        handleClick: () => {},
                        buttonText: "USSD",
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: FlutterwavePaymentOption(
                        handleClick: () => {},
                        buttonText: "Barter",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchCardPaymentWidget() {
    final CardPaymentManager cardPaymentManager =
        this.widget._flutterwavePaymentManager.getCardPaymentManager();
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => CardPayment(cardPaymentManager)),
    );
  }

  void _launchBankTransferPaymentWidget() {
    final BankTransferPaymentManager bankTransferPaymentManager =
        this.widget._flutterwavePaymentManager.getBankTransferPaymentManager();
    Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => BankTransfer(bankTransferPaymentManager)),
    );
  }
}
