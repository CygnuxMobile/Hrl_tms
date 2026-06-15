import 'dart:convert';

EwayBillResponse ewayBillResponseFromJson(String str) => EwayBillResponse.fromJson(json.decode(str));


class EwayBillResponse {
  final int statusCode;
  final int status;
  final Data data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  EwayBillResponse({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory EwayBillResponse.fromJson(Map<String, dynamic> json) => EwayBillResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

}

class Data {
  final int status;
  final String message;
  final String partyCode;
  final String partyName;
  final String invno;
  final String invdt;
  final double decval;
  final String eWayBillExpiredDate;
  final double eWayInvoicevalue;
  final String eWayBillInvoiceDate;
  final String fromCity;
  final String toCity;
  final String paybas;
  final String ewaybillNo;
  final int pincode;
  final String odaCategory;
  final String destcd;
  final String transMode;
  final String volYn;
  final String csgncd;
  final String csgnm;
  final String csgnAdd;
  final String csgecd;
  final String csgenm;
  final String csgeAdd;
  final int toPincode;
  final dynamic area;

  Data({
    required this.status,
    required this.message,
    required this.partyCode,
    required this.partyName,
    required this.invno,
    required this.invdt,
    required this.decval,
    required this.eWayBillExpiredDate,
    required this.eWayInvoicevalue,
    required this.eWayBillInvoiceDate,
    required this.fromCity,
    required this.toCity,
    required this.paybas,
    required this.ewaybillNo,
    required this.pincode,
    required this.odaCategory,
    required this.destcd,
    required this.transMode,
    required this.volYn,
    required this.csgncd,
    required this.csgnm,
    required this.csgnAdd,
    required this.csgecd,
    required this.csgenm,
    required this.csgeAdd,
    required this.toPincode,
    required this.area,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"] ?? 0,
    message: json["message"] ?? '',
    partyCode: json["partyCode"] ?? '',
    partyName: json["partyName"] ?? '',
    invno: json["invno"] ?? '',
    invdt: json["invdt"] ?? '',
    decval: (json["decval"] ?? 0).toDouble(),
    eWayBillExpiredDate: json["eWayBillExpiredDate"] ?? '',
    eWayInvoicevalue: (json["eWayInvoicevalue"] ?? 0).toDouble(),
    eWayBillInvoiceDate: json["eWayBillInvoiceDate"] ?? '',
    fromCity: json["fromCity"] ?? '',
    toCity: json["toCity"] ?? '',
    paybas: json["paybas"] ?? '',
    ewaybillNo: json["ewaybillNo"] ?? '',
    pincode: json["pincode"] ?? 0,
    odaCategory: json["odaCategory"] ?? '',
    destcd: json["destcd"] ?? '',
    transMode: json["transMode"] ?? '',
    volYn: json["vol_yn"] ?? '',
    csgncd: json["csgncd"] ?? '',
    csgnm: json["csgnm"] ?? '',
    csgnAdd: json["csgnAdd"] ?? '',
    csgecd: json["csgecd"] ?? '',
    csgenm: json["csgenm"] ?? '',
    csgeAdd: json["csgeAdd"] ?? '',
    toPincode: json["toPincode"] ?? 0,
    area: json["area"],
  );
}
