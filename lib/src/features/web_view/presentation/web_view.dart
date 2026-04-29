import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/web_view_controller.dart';

class WebViewScreen extends StatefulWidget {
  static const route = '/webView';
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<WebViewScreenController>(
          init: WebViewScreenController(),
          builder: (c) {
            return WebViewWidget(controller: c.webController);
          }
        ),
      ),
    );
  }
}