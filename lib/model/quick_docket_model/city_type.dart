import 'dart:convert';

CityTypeResponseModel cityTypeResponseModelFromJson(String str) => CityTypeResponseModel.fromJson(json.decode(str));

String cityTypeResponseModelToJson(CityTypeResponseModel data) => json.encode(data.toJson());

class CityTypeResponseModel {
  final int statusCode;
  final int status;
  final List<CityDatum> cityData;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  CityTypeResponseModel({
    required this.statusCode,
    required this.status,
    required this.cityData,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory CityTypeResponseModel.fromJson(Map<String, dynamic> json) => CityTypeResponseModel(
    statusCode: json["statusCode"],
    status: json["status"],
    cityData: List<CityDatum>.from(json["data"].map((x) => CityDatum.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "CityData": List<dynamic>.from(cityData.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class CityDatum {
  final String location;

  CityDatum({
    required this.location,
  });

  factory CityDatum.fromJson(Map<String, dynamic> json) => CityDatum(
    location: json["location"]??"",
  );

  Map<String, dynamic> toJson() => {
    "location": location,
  };
}
