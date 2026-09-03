import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/pay_model.dart';
import '../../../core/states/stateful_data.dart';

class PaymentVerificationController extends PaymentController {
  PaymentVerificationController(super.repository);

  bool check2 = false;

  late String? serviceName2;
  late String? serviceIcon2;
  late String? number2;
  late String? sum;
  late String? userName;
  late String? createdAt;
  late String? paymentUrl;
  late bool isInquiries2;
  late bool isFoundation2;
  late bool requiredPayment;
  bool delivery = false;
  String? cardPrice;
  String? deliveryPrice;


  late String? firstName;
  late String? lastName;
  late String? surname;
  late String? birthDate;
  late String? passportNumber;
  late String? issuedDate;
  late String? issuedBy;


  final profileBox = Hive.box<ProfileModel>('profileBox');


  @override
  void onInit() {
    final savedProfile = profileBox.get('currentProfile');

    firstName = savedProfile?.firstName;
    lastName = savedProfile?.lastName;
    surname = savedProfile?.middleName;
    birthDate = savedProfile?.birthDate;
    passportNumber = savedProfile?.passportNumber;
    issuedDate = savedProfile?.issuedDate;
    issuedBy = savedProfile?.issuedBy;

    try{
      serviceName2 = Get.arguments['serviceName'];
      serviceIcon2 = Get.arguments['serviceIcon'];
      isInquiries2 = Get.arguments['isInquiries'];
      isFoundation2 = Get.arguments['isFoundation'];
      number2 = Get.arguments['number'];
      sum = Get.arguments['sum']?.replaceAll('.', ',');
      userName = Get.arguments['userName'];
      createdAt = Get.arguments['createdAt'];
      paymentUrl = Get.arguments['paymentUrl'];
      requiredPayment = Get.arguments['requiredPayment'];
      selectedCard = Get.arguments['selectedCard'];
      delivery = Get.arguments['delivery'] == true;
      isGetCard = Get.arguments['cardPrice'] != null;
      cardPrice = Get.arguments['cardPrice']?.toString().replaceAll('.', ',');
      deliveryPrice = Get.arguments['deliveryPrice']?.toString().replaceAll('.', ',');
    }catch (e){
      debugPrint(e.toString());
    }

    super.onInit();
  }

  void startBankVerification2() {
    if(isInquiries == false) {
      saveCard();
    }
    check2 = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
      status = Status.completed;
      update();

    });

  }
  onTapPay(){
    if(selectedCard !=null) {
      openBankPayment(paymentUrl!, '');
    }
  }

  Future<void> saveCard() async {
    final box = Hive.box<PayModel>(isFoundation ? 'payFoundationBox' : 'payBox');
    final pay = PayModel(
      serviceName: serviceName2 ?? '',
      serviceIcon: serviceIcon2 ?? '',
      number: number2 ?? '',
      sum: sum ?? '',
      userName: userName ?? '',
    );
    await box.add(pay);
  }

}

