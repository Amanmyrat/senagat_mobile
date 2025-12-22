import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenController extends GetxController {
  late final WebViewController webController;

  @override
  void onInit() {
    super.onInit();

    final rawUrl = Get.arguments?['url']?.toString() ?? '';

    if (rawUrl.isEmpty) {
      Get.back();
      throw Exception('WebView URL is empty');
    }

    final url = rawUrl.startsWith('http')
        ? rawUrl
        : 'https://$rawUrl';

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..clearCache()
      ..loadRequest(Uri.parse(url));
  }
}


