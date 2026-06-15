import 'dart:convert';

TransportResponseModel transportResponseModelFromJson(String str) => TransportResponseModel.fromJson(json.decode(str));

String transportResponseModelToJson(TransportResponseModel data) => json.encode(data.toJson());

class TransportResponseModel {
  final int statusCode;
  final int status;
  final List<TransportDatum> transportData;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  TransportResponseModel({
    required this.statusCode,
    required this.status,
    required this.transportData,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory TransportResponseModel.fromJson(Map<String, dynamic> json) => TransportResponseModel(
    statusCode: json["statusCode"],
    status: json["status"],
    transportData: List<TransportDatum>.from(json["data"].map((x) => TransportDatum.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "transportData": List<dynamic>.from(transportData.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class TransportDatum {
  final String codeType;
  final String codeId;
  final String codeDesc;
  final String codeAccess;

  TransportDatum({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
    required this.codeAccess,
  });

  factory TransportDatum.fromJson(Map<String, dynamic> json) => TransportDatum(
    codeType: json["codeType"],
    codeId: json["codeId"],
    codeDesc: json["codeDesc"],
    codeAccess: json["codeAccess"],
  );

  Map<String, dynamic> toJson() => {
    "codeType": codeType,
    "codeId": codeId,
    "codeDesc": codeDesc,
    "codeAccess": codeAccess,
  };
}
