
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/endpoint.dart';
import '../config/model/resp.dart';
import '../config/network.dart';
import '../config/pref.dart';

class AuthViewmodel {

  Future<Resp> clients({String? clientId}) async {
    FormData formData = FormData.fromMap({
      'client_id': clientId,
    });
    var resp = await Network.postApi(Endpoint.clientUrl, formData);
    Resp data = Resp.fromJson(resp);
    return data;
  }

  Future<Resp> login({String? username, String? password}) async {

    var header = <String, dynamic>{
      'X-Tenant-Id': 'smkislamiyah',
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