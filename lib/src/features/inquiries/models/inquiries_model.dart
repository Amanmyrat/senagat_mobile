class InquiriesModel {
  final int? id;
  final String? title;
  final double? price;

  InquiriesModel({
    this.id,
    this.title,
    this.price,
  });

  factory InquiriesModel.fromJson(Map<String, dynamic> json) {
    return InquiriesModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

}
