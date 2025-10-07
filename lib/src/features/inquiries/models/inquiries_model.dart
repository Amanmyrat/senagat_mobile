class InquiriesModel {
  final int? id;
  final String? title;
  final String? price;

  InquiriesModel({
    this.id,
    this.title,
    this.price,
  });

  factory InquiriesModel.fromJson(Map<String, dynamic> json) {
    return InquiriesModel(
      id: json['id'],
      title: json['phone'],
      price: json['price'],
    );
  }



}
