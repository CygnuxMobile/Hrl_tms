import 'dart:convert';

DashBoardMenuItem dashBoardMenuItemFromJson(String str) => DashBoardMenuItem.fromJson(json.decode(str));

String dashBoardMenuItemToJson(DashBoardMenuItem data) => json.encode(data.toJson());

class DashBoardMenuItem {
  final int statusCode;
  final int status;
  final List<MenuListObject> menuList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  DashBoardMenuItem({
    required this.statusCode,
    required this.status,
    required this.menuList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  DashBoardMenuItem copyWith({
    int? statusCode,
    int? status,
    List<MenuListObject>? data,
    dynamic errors,
    dynamic metaData,
    String? message,
  }) =>
      DashBoardMenuItem(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        menuList: data ?? this.menuList,
        errors: errors ?? this.errors,
        metaData: metaData ?? this.metaData,
        message: message ?? this.message,
      );

  factory DashBoardMenuItem.fromJson(Map<String, dynamic> json) => DashBoardMenuItem(
    statusCode: json["statusCode"],
    status: json["status"],
    menuList: List<MenuListObject>.from(json["data"].map((x) => MenuListObject.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(menuList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class MenuListObject {
  final String userId;
  final String menuId;
  final String menuName;
  final bool hasAccess;

  MenuListObject({
    required this.userId,
    required this.menuId,
    required this.menuName,
    required this.hasAccess,
  });

  MenuListObject copyWith({
    String? userId,
    String? menuId,
    String? menuName,
    bool? hasAccess,
  }) =>
      MenuListObject(
        userId: userId ?? this.userId,
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        hasAccess: hasAccess ?? this.hasAccess,
      );

  factory MenuListObject.fromJson(Map<String, dynamic> json) => MenuListObject(
    userId: json["userId"] ?? "",
    menuId: json["menuId"] ?? "",
    menuName: json["menuName"] ?? "",
    hasAccess: json["hasAccess"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "menuId": menuId,
    "menuName": menuName,
    "hasAccess": hasAccess,
  };
}
