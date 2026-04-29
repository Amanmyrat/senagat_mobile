import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import '../../pay/model/pay_model.dart';

class FoundationController extends GetxController with StateControlMixin {

  late GlobalKey<FormState> key;

  final payBox = Hive.box<PayModel>('payFoundationBox');

}
