import 'dart:convert';

PackageType packageTypeFromJson(String str) => PackageType.fromJson(json.decode(str));

String packageTypeToJson(PackageType data) => json.encode(data.toJson());

class PackageType {
  final int statusCode;
  final int status;
  final List<PackageTypeObject> packageTypeList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  PackageType({
    required this.statusCode,
    required this.status,
    required this.packageTypeList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  PackageType copyWith({
    int? statusCode,
    int? status,
    List<PackageTypeObject>? data,
    dynamic errors,
    dynamic metaData,
    String? message,
  }) =>
      PackageType(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        packageTypeList: data ?? this.packageTypeList,
        errors: errors ?? this.errors,
        metaData: metaData ?? this.metaData,
        message: message ?? this.message,
      );

  factory PackageType.fromJson(Map<String, dynamic> json) => PackageType(
    statusCode: json["statusCode"],
    status: json["status"],
    packageTypeList: List<PackageTypeObject>.from(json["data"].map((x) => PackageTypeObject.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(packageTypeList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class PackageTypeObject {
  final String codeId;
  final String codeDesc;

  PackageTypeObject({
    required this.codeId,
    required this.codeDesc,
  });

  PackageTypeObject copyWith({
    String? codeId,
    String? codeDesc,
  }) =>
      PackageTypeObject(
        codeId: codeId ?? this.codeId,
        codeDesc: codeDesc ?? this.codeDesc,
      );

  factory PackageTypeObject.fromJson(Map<String, dynamic> json) => PackageTypeObject(
    codeId: json["codeId"] ?? '',
    codeDesc: json["codeDesc"] ??'',
  );

  Map<String, dynamic> toJson() => {
    "codeId": codeId,
    "codeDesc": codeDesc,
  };
}
