import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenController extends GetxController {
  late final WebViewController webController;

  @override
  void onInit() {
    super.onInit();



    final url = 'https://senagatbank.com.tm/branches-mobile';

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..clearCache()
      ..loadRequest(Uri.parse(url));
  }
}


