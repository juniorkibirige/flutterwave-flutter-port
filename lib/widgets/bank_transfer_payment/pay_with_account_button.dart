import 'package:flutter/material.dart';

class PayWithTransferButton extends StatelessWidget {
  final Function _payWithTransfer;

  PayWithTransferButton(this._payWithTransfer);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 100, 20, 20),
      child: ElevatedButton(
        onPressed: this._hanldePayWithTransfer,
        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
        ),
        child: Text(
          "PAY",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      // child: RaisedButton(
      //   onPressed: this._hanldePayWithTransfer,
      //   color: Colors.orange,
      //   child: Text(
      //     "PAY",
      //     style: TextStyle(color: Colors.white, fontSize: 15),
      //   ),
    );
  }

  void _hanldePayWithTransfer() {
    this._payWithTransfer();
  }
}
