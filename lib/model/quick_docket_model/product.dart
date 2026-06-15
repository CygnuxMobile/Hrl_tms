import 'dart:convert';

GetProduct getProductFromJson(String str) => GetProduct.fromJson(json.decode(str));

String getProductToJson(GetProduct data) => json.encode(data.toJson());

class GetProduct {
  final int statusCode;
  final int status;
  final List<ProductObject> productList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  GetProduct({
    required this.statusCode,
    required this.status,
    required this.productList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  GetProduct copyWith({
    int? statusCode,
    int? status,
    List<ProductObject>? data,
    dynamic errors,
    dynamic metaData,
    String? message,
  }) =>
      GetProduct(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        productList: data ?? this.productList,
        errors: errors ?? this.errors,
        metaData: metaData ?? this.metaData,
        message: message ?? this.message,
      );

  factory GetProduct.fromJson(Map<String, dynamic> json) => GetProduct(
    statusCode: json["statusCode"],
    status: json["status"],
    productList: List<ProductObject>.from(json["data"].map((x) => ProductObject.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(productList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class ProductObject {
  final String codeId;
  final String codeDesc;

  ProductObject({
    required this.codeId,
    required this.codeDesc,
  });

  ProductObject copyWith({
    String? codeId,
    String? codeDesc,
  }) =>
      ProductObject(
        codeId: codeId ?? this.codeId,
        codeDesc: codeDesc ?? this.codeDesc,
      );

  factory ProductObject.fromJson(Map<String, dynamic> json) => ProductObject(
    codeId: json["codeId"] ?? "",
    codeDesc: json["codeDesc"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "codeId": codeId,
    "codeDesc": codeDesc,
  };
}
