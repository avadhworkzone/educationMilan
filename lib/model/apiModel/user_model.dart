class UserModel {
  String? userId;
  String? phoneNumber;
  String? familyCode;

  UserModel({this.userId, this.phoneNumber, this.familyCode});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phoneNumber = json['phoneNumber'];
    familyCode = json['familyCode'];
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "phoneNumber": phoneNumber,
    "familyCode": familyCode,
  };
}
