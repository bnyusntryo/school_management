import 'dart:io';
import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class StaffViewModel {
  Future<Resp> getStaffList({
    String keyword = '',
    int limit = 20,
    int offset = 0,
  }) async {
    final token = await Session().getUserToken();

    final payload = {
      "filters": {
        "full_name": "",
        "userid": ""
      },
      "global": keyword,
      "limit": limit,
      "offset": offset,
      "sortField": "userid",
      "sortOrder": 1
    };

    final resp = await Network.postApiWithHeaders(
      Endpoint.staffInfoListUrl,
      payload,
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    return Resp.fromJson(resp);
  }

  Future<Resp> getStaffDetail(String userId) async {
    final token = await Session().getUserToken();
    final payload = {"staff_userid": userId};

    final resp = await Network.postApiWithHeaders(
      Endpoint.staffInfoDetailUrl,
      payload,
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    return Resp.fromJson(resp);
  }
}