import 'package:senagat_mobile/src/core/globals.dart';

class CardTypeModel {
  final int? id;
  final String? title;
  final String? category;
  final double? price;
  final String? image;
  final List<AdvantageModel>? advantages;

  static const String _baseUrl = Configs.baseUrl;

  CardTypeModel({
    this.id,
    this.title,
    this.category,
    this.price,
    this.image,
    this.advantages,
  });

  String? get imageUrl {
    if (image == null || image!.isEmpty) return null;

    if (image!.startsWith('http')) return image;

    return _baseUrl + image!;
  }

  factory CardTypeModel.fromJson(Map<String, dynamic> json) {
    return CardTypeModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      price: json['price'] == null ? null : (json['price'] as num).toDouble(),
      image: json['image_url'],
      advantages: (json['advantages'] as List<dynamic>?)
          ?.map((item) => AdvantageModel.fromJson(item))
          .toList(),
    );
  }
}

class AdvantageModel {
  final String? name;
  final String? description;

  AdvantageModel({
    this.name,
    this.description,
  });

  factory AdvantageModel.fromJson(Map<String, dynamic> json) {
    return AdvantageModel(
      name: json['name'],
      description: json['description'],
    );
  }
}
