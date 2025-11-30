import 'package:hive/hive.dart';

part 'card_model.g.dart';

@HiveType(typeId: 0)
class CardModel extends HiveObject {
  @HiveField(0)
  String cardNumber;

  @HiveField(1)
  String name;

  @HiveField(2)
  String expiryDate;

  @HiveField(3)
  String cardDesign;

  @HiveField(4)
  String nickName;

  CardModel({
    required this.cardNumber,
    required this.name,
    required this.expiryDate,
    required this.cardDesign,
    required this.nickName,
  });
}
