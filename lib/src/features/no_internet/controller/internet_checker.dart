import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetChecker extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool hasInternet = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Start listening
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        hasInternet.value = false;
        Get.toNamed('/no_internet');
      } else {
        if (Get.currentRoute == '/no_internet') {
          Get.back(); // Close no internet screen when back online
        }
        hasInternet.value = true;
      }
    });
  }
}
