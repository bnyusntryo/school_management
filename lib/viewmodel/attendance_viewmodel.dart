import 'dart:io';

import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class AttendanceViewmodel {
  Future<Resp> getAttendanceList() async {
    final token = await Session().getUserToken();
    final resp = await Network.getApiWithHeaders(
      Endpoint.attendanceListUrl,
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }

  Future<Resp> getTargetLocation() async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.attendanceLocationUrl,
      {},
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }

  Future<Resp> getTodayAttendanceLimit() async {
    final token = await Session().getUserToken();
    final resp = await Network.getApiWithHeaders(
      Endpoint.attendanceLimitUrl,
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }
}
