class CardTypeModel {
  final int? id;
  final String? title;
  final double? price;
  final String? image;
  final List<AdvantageModel>? advantages;

  CardTypeModel({
    this.id,
    this.title,
    this.price,
    this.image,
    this.advantages,
  });

  factory CardTypeModel.fromJson(Map<String, dynamic> json) {
    return CardTypeModel(
      id: json['id'],
      title: json['title'],
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
