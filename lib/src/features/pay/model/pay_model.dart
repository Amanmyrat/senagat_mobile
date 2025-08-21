import 'package:hive/hive.dart';

part 'pay_model.g.dart';

@HiveType(typeId: 1)
class PayModel extends HiveObject {
  @HiveField(0)
  String serviceName;

  @HiveField(1)
  String number;

  @HiveField(2)
  String sum;

  @HiveField(3)
  String userName;

  @HiveField(4)
  String serviceIcon;

  PayModel({
    required this.serviceName,
    required this.number,
    required this.sum,
    required this.userName,
    required this.serviceIcon
  });
}