import 'dart:convert';

LoginDetails loginDetailsFromJson(String str) => LoginDetails.fromJson(json.decode(str));

String loginDetailsToJson(LoginDetails data) => json.encode(data.toJson());

class LoginDetails {
  LoginDetails({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  final int statusCode;
  final int status;
  final UserData data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  factory LoginDetails.fromJson(Map<String, dynamic> json) => LoginDetails(
    statusCode: json["statusCode"],
    status: json["status"],
    data: UserData.fromJson(json["data"]),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": data.toJson(),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class UserData {
  UserData({
    required this.token,
    required this.tokenExpireTime,
    required this.userId,
    required this.name,
    required this.emailId,
    required this.userImage,
    required this.baseCompanyCode,
    required this.branchCode,
    required this.city,
    required this.finYear,
  });

  late final String token;
  final String tokenExpireTime;
  final String userId;
  final String name;
  final String emailId;
  final dynamic userImage;
  final String baseCompanyCode;
  final String branchCode;
  final String city;
  final String finYear;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    token: json["token"],
    tokenExpireTime: json["tokenExpireTime"],
    userId: json["userId"],
    name: json["name"],
    emailId: json["emailId"],
    userImage: json["userImage"],
    baseCompanyCode: json["baseCompanyCode"],
    branchCode: json["branchCode"],
    city:json["city"],
    finYear: json["finYear"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "tokenExpireTime": tokenExpireTime,
    "userId": userId,
    "name": name,
    "emailId": emailId,
    "userImage": userImage,
    "baseCompanyCode": baseCompanyCode,
    "branchCode": branchCode,
    "city": city,
    "finYear": finYear,
  };
}
