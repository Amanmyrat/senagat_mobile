import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:senagat_mobile/src/app.dart';
import 'package:senagat_mobile/src/core/local/key_value_storage_base.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/pay/model/pay_model.dart';
import 'package:senagat_mobile/src/utils/path_provider_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await PathProviderService.init();
  await KeyValueStorageBase.init();
  await Hive.initFlutter();

  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(PayModelAdapter());

  await Hive.openBox('fastOperations');
  await Hive.openBox<CardModel>('cardsBox');
  await Hive.openBox<PayModel>('payBox');
  await Hive.openBox<PayModel>('payFoundationBox');

  runApp(const SenagatApp());
}
