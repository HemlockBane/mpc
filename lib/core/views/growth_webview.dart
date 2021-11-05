import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GrowthWebView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GrowthWebView();

}

class _GrowthWebView extends State<GrowthWebView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: WebView(
              initialUrl: "https://flutter.dev",
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (request) async {
                print(request.url);
                return NavigationDecision.prevent;
              },
              onWebViewCreated: (controller) async {
                print("WebView ====> Created!!! ${await controller.currentUrl()}");
              },
              onWebResourceError: (error) {
                print("WebView ====> Error!!! ${error.description}");
              },
            )
        )
      ],
    );
  }

}