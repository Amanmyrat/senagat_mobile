import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:senagat_mobile/src/app.dart';
import 'package:senagat_mobile/src/core/local/key_value_storage_base.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/category/model/fast_service_model.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import 'package:senagat_mobile/src/features/pay/model/pay_model.dart';
import 'package:senagat_mobile/src/utils/localization/localization_service.dart';
import 'package:senagat_mobile/src/utils/path_provider_service.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PathProviderService.init();
  await KeyValueStorageBase.init();
  await Hive.initFlutter();
  await LocalizationService.init();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(PayModelAdapter());
  Hive.registerAdapter(ProfileModelAdapter());
  Hive.registerAdapter(FastServiceItemAdapter());

  await Hive.openBox<ProfileModel>('profileBox');
  await Hive.openBox('fastOperations');
  await Hive.openBox<String>('phoneBox');
  await Hive.openBox<CardModel>('cardsBox');
  await Hive.openBox<PayModel>('payBox');
  await Hive.openBox<PayModel>('payFoundationBox');
  await Hive.openBox('accountsBox');
  await Hive.openBox<FastServiceItem>('fastServices');


  runApp(const SenagatApp());
}
