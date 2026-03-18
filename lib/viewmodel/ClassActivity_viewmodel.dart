import '../config/network.dart';
import '../config/endpoint.dart';
import '../config/pref.dart';
import '../config/model/resp.dart';

class ClassActivityViewmodel {

  Future<Resp> fetchClassDetail(String classCode) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var payload = {"class_code": classCode};

    final res = await Network.postApiWithHeaders(Endpoint.classDetailUrl, payload, headers);

    return Resp.fromJson(res);
  }

  Future<Resp> fetchSubjectList(String classCode) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var payload = {
      "limit": 100,
      "offset": 0,
      "sortField": "subjectclass_code",
      "sortOrder": 1,
      "filters": {},
      "global": "",
      "class_code": classCode
    };

    final res = await Network.postApiWithHeaders(Endpoint.subjectListUrl, payload, headers);
    return Resp.fromJson(res);
  }

  Future<Resp> fetchClassList() async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var payload = {
      "limit": 100,
      "offset": 0,
      "sortField": "subjectclass_code",
      "sortOrder": 1,
      "filters": {},
      "global": ""
    };

    final res = await Network.postApiWithHeaders(Endpoint.classListUrl, payload, headers);

    return Resp.fromJson(res);
  }

  Future<Resp> fetchSubjectDetail(String subjectClassCode) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var payload = {"subjectclass_code": subjectClassCode};
    final res = await Network.postApiWithHeaders(Endpoint.subjectDetailUrl, payload, headers);
    return Resp.fromJson(res);
  }

  Future<Resp> fetchActivityList(String classCode, String subjectClassCode) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var payload = {
      "limit": 100,
      "offset": 0,
      "sortField": "created_at",
      "sortOrder": -1,
      "filters": {},
      "global": "",
      "class_code": classCode,
      "subjectclass_code": subjectClassCode
    };

    final res = await Network.postApiWithHeaders(Endpoint.activityListUrl, payload, headers);
    return Resp.fromJson(res);
  }

  Future<Resp> fetchActivityDetail(String activityId, String subjectClassCode) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var payload = {"classactivity_id": activityId, "subjectclass_code": subjectClassCode};
    final res = await Network.postApiWithHeaders(Endpoint.activityDetailUrl, payload, headers);
    return Resp.fromJson(res);
  }

  Future<Resp> fetchStudentList(String activityId, String subjectClassCode) async {
    String? token = await Session().getUserToken();
    Map<String, dynamic> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var payload = {"classactivity_id": activityId, "subjectclass_code": subjectClassCode};
    final res = await Network.postApiWithHeaders(Endpoint.studentListUrl, payload, headers);
    return Resp.fromJson(res);
  }
}