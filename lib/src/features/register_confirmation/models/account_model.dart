class AccountModel {
  final int? id;
  final String? phoneNumber;
  final String? token;

  AccountModel({
    this.id,
    this.phoneNumber,
    this.token,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      phoneNumber: json['phone'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "phone": phoneNumber,
      "token": token,
    };
  }

}
