import 'dart:convert';
DrsUpdateListRequest drsUpdateListRequestFromJson(String str) =>
    DrsUpdateListRequest.fromJson(json.decode(str));

String drsUpdateListRequestToJson(DrsUpdateListRequest data) =>
    json.encode(data.toJson());

class DrsUpdateListRequest {
  final String baseLocationCode;
  final String dateFrom;
  final String dateTo;
  final String baseCompanyCode;

  DrsUpdateListRequest({
    required this.baseLocationCode,
    required this.dateFrom,
    required this.dateTo,
    required this.baseCompanyCode,
  });

  factory DrsUpdateListRequest.fromJson(Map<String, dynamic> json) =>
      DrsUpdateListRequest(
        baseLocationCode: json["baseLocationCode"],
        dateFrom: json["dateFrom"],
        dateTo: json["dateTo"],
        baseCompanyCode: json["baseCompanyCode"],
      );

  Map<String, dynamic> toJson() => {
        "baseLocationCode": baseLocationCode,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
        "baseCompanyCode": baseCompanyCode,
      };
}
