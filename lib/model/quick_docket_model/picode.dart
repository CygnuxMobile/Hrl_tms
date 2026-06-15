import 'dart:convert';

PinCode pinCodeFromJson(String str) => PinCode.fromJson(json.decode(str));

String pinCodeToJson(PinCode data) => json.encode(data.toJson());

class PinCode {
  final int statusCode;
  final int status;
  final List<pinCodeObject> pinCodeList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  PinCode({
    required this.statusCode,
    required this.status,
    required this.pinCodeList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  PinCode copyWith({
    int? statusCode,
    int? status,
    List<pinCodeObject>? data,
    dynamic errors,
    dynamic metaData,
    String? message,
  }) =>
      PinCode(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        pinCodeList: data ?? this.pinCodeList,
        errors: errors ?? this.errors,
        metaData: metaData ?? this.metaData,
        message: message ?? this.message,
      );

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
    statusCode: json["statusCode"],
    status: json["status"],
    pinCodeList: List<pinCodeObject>.from(json["data"].map((x) => pinCodeObject.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(pinCodeList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class pinCodeObject {
  final String value;
  final String text;
  final dynamic odAcategory;
  final dynamic destination;
  final String toCity;

  pinCodeObject({
    required this.value,
    required this.text,
    required this.odAcategory,
    required this.destination,
    required this.toCity,
  });

  pinCodeObject copyWith({
    String? value,
    String? text,
    dynamic odAcategory,
    dynamic destination,
    String? toCity,
  }) =>
      pinCodeObject(
        value: value ?? this.value,
        text: text ?? this.text,
        odAcategory: odAcategory ?? this.odAcategory,
        destination: destination ?? this.destination,
        toCity: toCity ?? this.toCity,
      );

  factory pinCodeObject.fromJson(Map<String, dynamic> json) => pinCodeObject(
    value: json["value"] ?? '',
    text: json["text"] ?? '',
    odAcategory: json["odAcategory"] ?? '',
    destination: json["destination"] ?? '',
    toCity: json["toCity"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "text": text,
    "odAcategory": odAcategory,
    "destination": destination,
    "toCity": toCity,
  };
}
