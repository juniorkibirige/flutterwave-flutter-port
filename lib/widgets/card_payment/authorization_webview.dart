import 'dart:convert';

import 'package:flutter/material.dart';
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
    if (url != this.widget._url) {
      this._onValidationSuccessful(url);
    }
  }

  void _onValidationSuccessful(String url) {
    final response = Uri.dataFromString(url).queryParameters["response"];
    if (response != null) {
      final String responseString = Uri.decodeFull(response);
      final Map data = json.decode(responseString);
      if (data["status"] == "successful") {
        final String flwRef = data["flwRef"];
        Navigator.pop(this.context, flwRef);
      }
    }
  }
}

