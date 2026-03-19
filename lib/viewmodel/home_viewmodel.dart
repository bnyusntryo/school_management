import 'dart:io';

import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class HomeViewmodel {
  Future<Resp> getAnnouncements() async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.announcementUrl,
      {},
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }

  Future<Resp> getTodayClass() async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.todayClassUrl,
      {},
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }

  Future<Resp> getFeedList() async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.feedListUrl,
      {},
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }
}
