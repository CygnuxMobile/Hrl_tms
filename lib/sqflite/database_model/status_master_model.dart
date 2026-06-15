// To parse this JSON data, do
//
//     final statusMasterModel = statusMasterModelFromJson(jsonString);

import 'dart:convert';

List<StatusMasterModel> statusMasterModelListFromJson(String str) =>
    List<StatusMasterModel>.from(
        json.decode(str)!.map((x) => StatusMasterModel.fromJson(x)));

StatusMasterModel statusMasterModelFromJson(String str) =>
    StatusMasterModel.fromJson(json.decode(str));

String statusMasterModelToJson(StatusMasterModel data) =>
    json.encode(data.toJson());

enum StatusMasterEnum {
  newTest,
  running,
  stopped,
  completed;

  static StatusMasterEnum enumFromIndex(int value) =>
      StatusMasterEnum.values.firstWhere((element) => element.index == value);

  static StatusMasterEnum enumFromString(String value) =>
      StatusMasterEnum.values.firstWhere((element) => element.name == value);
}

class StatusMasterModel {
  StatusMasterModel({
    required this.id,
    required this.description,
  });

  final int id;
  final String description;

  StatusMasterModel copyWith({
    int? id,
    String? description,
  }) =>
      StatusMasterModel(
        id: id ?? this.id,
        description: description ?? this.description,
      );

  factory StatusMasterModel.fromJson(Map<String, dynamic> json) =>
      StatusMasterModel(
        id: json["_id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "description": description,
      };
}
