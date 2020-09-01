import 'package:flutter/material.dart';
import 'package:flutterwave/core/bank_transfer_manager/bank_transfer_payment_manager.dart';
import 'package:flutterwave/core/card_payment_manager/card_payment_manager.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';
import 'package:flutterwave/core/mobile_money/mobile_money_payment_manager.dart';
import 'package:flutterwave/core/mpesa/mpesa_payment_manager.dart';
import 'package:flutterwave/core/pay_with_account_manager/bank_account_manager.dart';
import 'package:flutterwave/core/ussd_payment_manager/ussd_manager.dart';
import 'package:flutterwave/widgets/bank_account_payment/bank_account_payment.dart';
import 'package:flutterwave/widgets/bank_transfer_payment/bank_transfer_payment.dart';
import 'package:flutterwave/widgets/card_payment/card_payment.dart';
import 'package:flutterwave/widgets/mobile_money/pay_with_mobile_money.dart';
import 'package:flutterwave/widgets/mpesa_payment/pay_with_mpesa.dart';
import 'package:flutterwave/widgets/ussd_payment/pay_with_ussd.dart';

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
    final FlutterwavePaymentManager paymentManager =
        this.widget._flutterwavePaymentManager;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 70, 10, 0),
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
                      margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 5,
                        width: 200,
                        color: Colors.pink,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 100.0,
              ),
              Container(
                color: Colors.white38,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Visibility(
                      visible: paymentManager.acceptAccountPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchAccountWidget,
                              buttonText: "Account",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptCardPayment,
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptBankTransferPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick:
                                  this._launchBankTransferPaymentWidget,
                              buttonText: "Bank Transfer",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptUSSDPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchUSSDPaymentWidget,
                              buttonText: "USSD",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptMpesaPayment,
                      child: Column(children: [
                        SizedBox(
                          height: 50.0,
                          child: FlutterwavePaymentOption(
                            handleClick: this._launchMpesaPaymentWidget,
                            buttonText: "Mpesa",
                          ),
                        ),
                        SizedBox(
                          height: 0.5,
                        ),
                      ]),
                    ),
                    Visibility(
                      visible: paymentManager.acceptRwandaMoneyPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchMobileMoneyPaymentWidget,
                              buttonText: "Rwanda Mobile Money",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptGhanaPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchMobileMoneyPaymentWidget,
                              buttonText: "Ghana Mobile Money",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptUgandaPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchMobileMoneyPaymentWidget,
                              buttonText: "Uganda Mobile Money",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptZambiaPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchMobileMoneyPaymentWidget,
                              buttonText: "Zambia Mobile Money",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: paymentManager.acceptFancophoneMobileMoney,
                      child: SizedBox(
                        height: 50.0,
                        child: FlutterwavePaymentOption(
                          handleClick: this._launchMobileMoneyPaymentWidget,
                          buttonText: "Francophone Mobile Money",
                        ),
                      ),
                    )
                  ],
                ),
              )
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

  void _launchAccountWidget() {
    final BankAccountPaymentManager bankAccountPaymentManager =
        this.widget._flutterwavePaymentManager.getBankAccountPaymentManager();
    Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => RequestBankAccount(bankAccountPaymentManager)),
    );
  }

  void _launchUSSDPaymentWidget() async {
    final USSDPaymentManager paymentManager =
        this.widget._flutterwavePaymentManager.getUSSDPaymentManager();
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => PayWithUssd(paymentManager)),
    );
  }

  void _launchMobileMoneyPaymentWidget() async {
    final MobileMoneyPaymentManager mobileMoneyPaymentManager =
        this.widget._flutterwavePaymentManager.getMobileMoneyPaymentManager();
    Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => PayWithMobileMoney(mobileMoneyPaymentManager)),
    );
  }

  void _launchMpesaPaymentWidget() async {
    final FlutterwavePaymentManager paymentManager =
        this.widget._flutterwavePaymentManager;
    final MpesaPaymentManager mpesaPaymentManager =
        paymentManager.getMpesaPaymentManager();
    Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => PayWithMpesa(mpesaPaymentManager)),
    );
  }
}
