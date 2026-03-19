import 'dart:io';

import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class FeedViewmodel {
  Future<Resp> getComments({required String feedpostId}) async {
    final token = await Session().getUserToken();
    final resp = await Network.postApiWithHeaders(
      Endpoint.feedCommentListUrl,
      {'feedpost_id': feedpostId},
      {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return Resp.fromJson(resp);
  }
}
