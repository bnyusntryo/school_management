import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class AuthViewmodel {

  Future<Resp> clients({String? clientId}) async {

    var body = {
      'client_id': clientId,
    };

    var resp = await Network.postApi(
      Endpoint.clientUrl,
      body,
    );

    return Resp.fromJson(resp);
  }

  Future<Resp> login({String? username, String? password}) async {

    String? clientId = await Session().getClientId();

    var header = {
      'X-Tenant-Id': clientId,
    };

    var body = {
      'username': username,
      'password': password,
    };

    var resp = await Network.postApiWithHeaders(
        Endpoint.authLoginUrl,
        body,
        header
    );

    return Resp.fromJson(resp);
  }
}