import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

GetPodListRes getPodListResFromJson(String str) =>
    GetPodListRes.fromJson(json.decode(str));
GetPodListRes getPodUploadImageFromJson(String str) =>
    GetPodListRes.uploadImagefromJson(json.decode(str));

String getPodListResToJson(GetPodListRes data) => json.encode(data.toJson());

class GetPodListRes {
  final int? statusCode;
  final int? status;
  final Data? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  GetPodListRes({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  factory GetPodListRes.fromJson(Map<String, dynamic> json) => GetPodListRes(
        statusCode: json["statusCode"],
        status: json["status"],
        data: Data.fromJson(json["data"] ?? []),
        errors: json["errors"],
        metaData: json["metaData"],
        message: json["message"],
      );

  factory GetPodListRes.uploadImagefromJson(Map<String, dynamic> json) =>
      GetPodListRes(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "data": data?.toJson(),
        "errors": errors,
        "metaData": metaData,
        "message": message,
      };
}

class Data {
  final List<Pod> pod;

  Data({
    this.pod = const [],
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pod: List<Pod>.from(json["pod"].map((x) => Pod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pod": List<dynamic>.from(pod.map((x) => x.toJson())),
      };
}

class Pod {
  final String? dockno;
  final String? dockdt;
  RxList<File> selectedImages = <File>[].obs;

  Pod({
    this.dockno,
    this.dockdt,
  });

  factory Pod.fromJson(Map<String, dynamic> json) => Pod(
        dockno: json["dockno"],
        dockdt: json["dockdt"],
      );

  Map<String, dynamic> toJson() => {
        "dockno": dockno,
        "dockdt": dockdt,
      };
}
