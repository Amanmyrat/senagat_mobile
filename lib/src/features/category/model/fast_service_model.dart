import 'package:hive/hive.dart';

part 'fast_service_model.g.dart';

@HiveType(typeId: 1)
class FastServiceItem extends HiveObject {
  @HiveField(0)
  String type;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String title;

  @HiveField(3)
  String icon;

  @HiveField(4)
  String? balance;

  FastServiceItem({
    required this.type,
    required this.phone,
    required this.title,
    required this.icon,
    this.balance,
  });
}