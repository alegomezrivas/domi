import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DomiWebView extends StatefulWidget {
  final String url;

  DomiWebView({required this.url});

  @override
  _DomiWebViewState createState() => _DomiWebViewState();
}

class _DomiWebViewState extends State<DomiWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
      ),
    );
  }
}
