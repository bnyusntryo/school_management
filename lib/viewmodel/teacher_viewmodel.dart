// 1. Buat TeacherViewModel
import 'dart:io';

import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class TeacherViewmodel {
  Future<Resp> getTeacherList({
    required int limit,
    required int offset,
    String? nameFilter
  }) async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.teacherInfoListUrl,
      {
        "limit": limit,
        "offset": offset,
        "filters": {"full_name": nameFilter ?? "", "userid": ""},
        "global": ""
      },
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }

  Future<Resp> getTeacherPersonal({required String teacherUserid}) async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.teacherInfoPersonalUrl, // Tambahkan di endpoint.dart
      {"teacher_userid": teacherUserid},
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }
}