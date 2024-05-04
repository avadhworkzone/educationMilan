class UserModel {
  String? userId;
  String? phoneNumber;
  String? userPin;


  UserModel({
    this.userId,
    this.phoneNumber,
    this.userPin,

  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phoneNumber = json['phoneNumber'];
    userPin = json['userPin'];

  }

  Map<String, dynamic> toJson() => {
    "userId" : userId,
    "phoneNumber": phoneNumber,
    "userPin" : userPin,

  };

  Map<String, dynamic> updateToJson() => {
    "phoneNumber": phoneNumber,
  };
}
