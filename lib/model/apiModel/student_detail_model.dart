class StudentModel {
  String? userId;
  String? studentFullName;
  String? mobileNumber;
  String? villageName;
  String? standard;
  num? percentage;
  String? result;
  String? imageId;
  String? studentId;
  String? createdDate;
  String? documentStatus;
  String? documentReason;
  String? fcmToken;
  bool? isApproved;

  StudentModel(
      {this.userId,
      this.studentFullName,
      this.mobileNumber,
      this.villageName,
      this.standard,
      this.result,
      this.imageId,
      this.percentage,
      this.studentId,
      this.createdDate,
      this.documentStatus,
      this.documentReason,
      this.isApproved});

  StudentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    studentFullName = json['studentFullName'];
    villageName = json['villageName'];
    standard = json['standard'];
    result = json['result'];
    fcmToken = json['fcmToken'];
    imageId = json['imageId'];
    percentage = json['percentage'];
    studentId = json['studentId'];
    createdDate = json['createdDate'];
    isApproved = json['isApproved'];
    documentStatus = json['status'];
    documentReason = json['reason'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "studentFullName": studentFullName,
        "villageName": villageName,
        "standard": standard,
        "result": result,
        "imageId": imageId,
        "percentage": percentage,
        "studentId": studentId,
        "createdDate": createdDate,
        "isApproved": isApproved,
        "status": documentStatus,
        "reason": documentReason,
        "fcmToken": fcmToken,
        "mobileNumber": mobileNumber,
      };

  Map<String, dynamic> updateToJson() => {
        "studentFullName": studentFullName,
      };
}
