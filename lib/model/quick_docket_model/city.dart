import 'dart:convert';

CityResponse cityResponseFromJson(String str) => CityResponse.fromJson(json.decode(str));

String cityResponseToJson(CityResponse data) => json.encode(data.toJson());

class CityResponse {
  final int statusCode;
  final int status;
  final List<CityObject> cityList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  CityResponse({
    required this.statusCode,
    required this.status,
    required this.cityList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  CityResponse copyWith({
    int? statusCode,
    int? status,
    List<CityObject>? data,
    dynamic errors,
    dynamic metaData,
    String? message,
  }) =>
      CityResponse(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        cityList: data ?? this.cityList,
        errors: errors ?? this.errors,
        metaData: metaData ?? this.metaData,
        message: message ?? this.message,
      );

  factory CityResponse.fromJson(Map<String, dynamic> json) => CityResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    cityList: List<CityObject>.from(json["data"].map((x) => CityObject.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(cityList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class CityObject {
  final String location;

  CityObject({
    required this.location,
  });

  CityObject copyWith({
    String? location,
  }) =>
      CityObject(
        location: location ?? this.location,
      );

  factory CityObject.fromJson(Map<String, dynamic> json) => CityObject(
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "location": location,
  };
}
