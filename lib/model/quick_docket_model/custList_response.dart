import 'dart:convert';

CustListResponse custListResponseFromJson(String str) =>
    CustListResponse.fromJson(json.decode(str));

class CustListResponse {
  final int statusCode;
  final int status;
  final List<CustList> custList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  CustListResponse({
    required this.statusCode,
    required this.status,
    required this.custList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory CustListResponse.fromJson(Map<String, dynamic> json) =>
      CustListResponse(
        statusCode: json["statusCode"],
        status: json["status"],
        custList:
            List<CustList>.from(json["data"].map((x) => CustList.fromJson(x))),
        errors: json["errors"],
        metaData: json["metaData"],
        message: json["message"],
      );
}

class CustList {
  final String custcd;
  final String custnm;
  final String volYn;
  final String transType;

  CustList({
    required this.custcd,
    required this.custnm,
    required this.volYn,
    required this.transType,
  });

  factory CustList.fromJson(Map<String, dynamic> json) => CustList(
        custcd: json["custcd"] ?? "",
        custnm: json["custnm"] ?? "",
        volYn: json["vol_yn"] ?? '',
        transType: json["trans_type"] ?? '',
      );
}
