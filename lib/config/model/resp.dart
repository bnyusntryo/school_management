import 'dart:convert';

// import '../../model/pagination.dart';


class Resp {
  int? code;
  dynamic error;
  dynamic status;
  dynamic message;
  dynamic categories;
  dynamic data;
  dynamic success;
  dynamic type;
  // Pagination? pagination;

  Resp({
    this.error,
    this.code,
    this.status,
    this.message,
    this.data,
    this.type,
    this.categories,
    // this.pagination,
  });
  factory Resp.fromRawJson(String str) => Resp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  @override
  String toString() => json.encode(this);

  factory Resp.fromJson(Map<String, dynamic> json) => Resp(
    code: json["code"],
    error: json["error"],
    status: json["status"],
    message: json["message"],
    data: json["data"],
    type: json["type"],
    categories: json["categories"],
    // pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );
  Map<String, dynamic> toJson() => {
    "code": code,
    "error": error,
    "status": status,
    "message": message,
    "data": data,
    "type": type,
    "categories": categories,
    // "pagination": pagination?.toJson(),
  };
}
