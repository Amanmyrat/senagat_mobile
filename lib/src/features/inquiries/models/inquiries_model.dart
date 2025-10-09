import 'package:hive/hive.dart';

part 'inquiries_model.g.dart';

@HiveType(typeId: 0)
class InquiriesModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? price;

  InquiriesModel({
    this.id,
    this.title,
    this.price,
  });

  factory InquiriesModel.fromJson(Map<String, dynamic> json) {
    return InquiriesModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
  };
}

