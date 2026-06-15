// To parse this JSON data, do
//
//     final podTableModel = podTableModelFromJson(jsonString);

import 'dart:convert';

List<PodTableModel> podTableListModelFromJson(String str) =>
    List<PodTableModel>.from(
        json.decode(str)!.map((x) => PodTableModel.fromJson(x)));

String podTableListModelToJson(List<PodTableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

PodTableModel podTableModelFromJson(String str) => PodTableModel.fromJson(json.decode(str));

String podTableModelToJson(PodTableModel data) => json.encode(data.toJson());

class PodTableModel {
  final int? id;
  final String docNo;
  final String podImage;
  final int status;

  PodTableModel({
    this.id,
    required this.docNo,
    required this.podImage,
    required this.status,
  });

  factory PodTableModel.fromJson(Map<String, dynamic> json) => PodTableModel(
    id: json["_Id"],
    docNo: json["docNo"],
    podImage: json["podImage"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "_Id":id,
    "docNo": docNo,
    "podImage": podImage,
    "status": status,
  };
  Map<String, dynamic> toJsonWithOutId() => {
    "docNo": docNo,
    "podImage": podImage,
    "status": status,
  };

}
