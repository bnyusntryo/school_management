import '../config/network.dart';
import '../config/endpoint.dart';
import '../config/pref.dart';
import '../config/model/resp.dart';

class SchoolActivityReportsViewModel {
  Future<Resp> fetchClassListForReport() async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var payload = {"user_status": ""};

    final res = await Network.postApiWithHeaders(Endpoint.reportGetClassUrl, payload, headers);

    return Resp.fromJson(res);
  }

  Future<Resp> generateReportData({
    required String startDate,
    required String endDate,
    required List<String> classCodes,
  }) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var payload = {
      "start_date": startDate,
      "end_date": endDate,
      "class_code": classCodes
    };

    final res = await Network.postApiWithHeaders(Endpoint.reportSubmitUrl, payload, headers);

    return Resp.fromJson(res);
  }
}