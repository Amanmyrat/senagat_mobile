import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:senagat_mobile/src/app.dart';
import 'package:senagat_mobile/src/core/local/key_value_storage_base.dart';
import 'package:senagat_mobile/src/utils/path_provider_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await PathProviderService.init();
  await KeyValueStorageBase.init();

  runApp(const SenagatApp());
}
