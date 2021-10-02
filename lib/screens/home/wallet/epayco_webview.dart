import 'package:domi/core/extensions/string.dart';
import 'package:domi/core/network/api_keys.dart';
import 'package:domi/main.dart';
import 'package:domi/models/wallet/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:collection';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EpaycoWebView extends StatefulWidget {
  final UserTransaction transaction;

  EpaycoWebView(this.transaction);

  @override
  _EpaycoWebViewState createState() => _EpaycoWebViewState();
}

class _EpaycoWebViewState extends State<EpaycoWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Recarga de saldo")),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  // contextMenu: contextMenu,
                  // initialUrlRequest:
                  // URLRequest(url: Uri.parse("https://github.com/flutter")),
                  initialFile: "assets/html/epayco.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    print(this.url);
                    if (this.url.contains("https://epayco.com/?ref_payco")) {
                      Navigator.of(context).pop();
                    }
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    // if (![
                    //   "http",
                    //   "https",
                    //   "file",
                    //   "chrome",
                    //   "data",
                    //   "javascript",
                    //   "about"
                    // ].contains(uri.scheme)) {
                    //   if (await canLaunch(url)) {
                    //     // Launch the App
                    //     await launch(
                    //       url,
                    //     );
                    //     // and cancel the request
                    //     return NavigationActionPolicy.CANCEL;
                    //   }
                    // }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      _starEpaycoCheckout();
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
        ])));
  }

  _starEpaycoCheckout() async {
    webViewController?.evaluateJavascript(source: """
        var handler = ePayco.checkout.configure({
            key: '$kEPAYCO_KEY',
            test: $kEPAYCO_TEST
        });
        var data = {
            name: "Recarga Indomi",
            description: "Recarga de saldo Indomi...",
            invoice: ${widget.transaction.id},
            currency: "cop",
            amount: ${widget.transaction.total!.toDouble()},
            tax_base: "0",
            tax: "0",
            country: "co",
            lang: "en",
            external: "true",
            extra1: "extra1",
            extra2: "extra2",
            extra3: "extra3",
            confirmation: "$kEPAYCO_CONFIRMATION",
            ${context.read(authProvider).userData!.user.isDomi ? 'methodsDisable: ["TDC", "PSE","SP","CASH"]' : ""}
        };

        handler.open(data);
                      """).catchError((onError) {
      print("error $onError");
    });
  }
}
