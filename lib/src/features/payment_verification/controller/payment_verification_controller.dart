import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';
import 'package:senagat_mobile/src/features/pay/model/pay_model.dart';
import '../../../core/states/stateful_data.dart';

class PaymentVerificationController extends GetxController with StateControlMixin {

  bool check = false;

  late String? serviceName;
  late String? serviceIcon;
  late String? number;
  late String? sum;
  late String? userName;
  late String? createdAt;
  late bool isInquiries;
  late bool isFoundation;

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
      serviceName = Get.arguments['serviceName'];
      serviceIcon = Get.arguments['serviceIcon'];
      isInquiries = Get.arguments['isInquiries'];
      isFoundation = Get.arguments['isFoundation'];
      number = Get.arguments['number'];
      sum = Get.arguments['sum']?.replaceAll('.', ',');
      userName = Get.arguments['userName'];
      createdAt = Get.arguments['createdAt'];
    }catch (e){
      print(e);
    }

    super.onInit();
  }

  void startBankVerification() {
    if(isInquiries == false) {
      saveCard();
    }
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
      status = Status.completed;
      update();

    });

  }

  Future<void> saveCard() async {
    final box = Hive.box<PayModel>(isFoundation ? 'payFoundationBox' : 'payBox');
    final pay = PayModel(
      serviceName: serviceName ?? '',
      serviceIcon: serviceIcon ?? '',
      number: number ?? '',
      sum: sum ?? '',
      userName: userName ?? '',
    );
    await box.add(pay);
  }

}

