import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationWebview extends StatefulWidget {
  final String _url;

  AuthorizationWebview(this._url);

  @override
  _AuthorizationWebviewState createState() => _AuthorizationWebviewState();
}

class _AuthorizationWebviewState extends State<AuthorizationWebview> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: WebView(
            initialUrl: this.widget._url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: this._pageStarted,
          ),
        ),
      ),
    );
  }

  void _pageStarted(String url) {
  final bool startsWithMyRedirectUrl = url.toString().indexOf(FlutterwaveUtils.DEFAULT_REDIRECT_URL.toString()) == 0;
    print("url in webview isss $url");
    print("url index is ${url.toString().indexOf(FlutterwaveUtils.DEFAULT_REDIRECT_URL.toString())}");
    print("startsWithMyRedirectUrl $startsWithMyRedirectUrl");
    if (url != this.widget._url && startsWithMyRedirectUrl) {
      this._onValidationSuccessful(url);
    } else {
      print("startsWithMyRedirectUrl $startsWithMyRedirectUrl");
    }
  }

  void _onValidationSuccessful(String url) {
    print("onValidation successful");
    var response = Uri.dataFromString(url).queryParameters["response"];
    var resp = Uri.dataFromString(url).queryParameters["resp"];
    if (response != null) {
      print("response is not null");
      final String responseString = Uri.decodeFull(response);
      final Map data = json.decode(responseString);
      print("response from weview is $responseString");
      if (data["status"] == "successful") {
        final String flwRef = data["flwRef"];
        Navigator.pop(this.context, flwRef);
      } else {
        Navigator.pop(this.context, {"error" : data["message"]});
      }
      return;
    }
    if (resp != null) {
      final String responseString = Uri.decodeFull(resp);
      final Map map = json.decode(responseString);
      if (map["status"] == "success") {
        final String flwRef = map["data"]["flwRef"];
        Navigator.pop(this.context, flwRef);
      } else {
        Navigator.pop(this.context, {"error" : map["message"]});
      }
      return;
    }
    print("resp and response are null");
    return;
  }
}
