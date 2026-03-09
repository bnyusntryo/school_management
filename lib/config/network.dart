import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'model/resp.dart';

// final baseUrl = '';
// final baseUrl = dotenv.env['BASEURL_PRODUCTION']!;
String get _baseUrl => dotenv.env['BASEURL_STAGING'] ?? 'https://example.com';

class Network {
  static final Network _instance = Network._internal();
  factory Network() => _instance;
  Network._internal();
  static Future<dynamic> postApi(String url, dynamic formData, {String? baseUrl}) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
                contentType: 'application/json',
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response rest = await dio.post(url, data: formData);
      dio.close();
      return rest.data;
    } on DioException catch (e) {
      debugPrint('DioException caught in POST $url: $e');
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  static Future<dynamic> postApiWithHeaders(
    String url,
    body,
    Map<String, dynamic> header,
      {String? baseUrl,}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restValue = await dio.post(
        url,
        data: body,
        options: Options(headers: header),
      );
      dio.close();
      header.clear();
      return restValue.data;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response?.toString());
        Resp resp  = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  static Future<dynamic> postApiWithHeadersWithoutData(
    String url,
    Map<String, dynamic> header,
      {String? baseUrl,}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restValue = await dio.post(
        url,
        options: Options(headers: header),
      );
      dio.close();
      header.clear();
      return restValue.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  Future<dynamic> postApiWithHeadersContentType(
    String url,
    dynamic body,
    Map<String, dynamic> header,
      {String? baseUrl,}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl  ,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
                contentType: 'application/json',
                headers: header,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restValue = await dio.post(
        url,
        data: body,
        options: Options(headers: header, contentType: Headers.jsonContentType),
      );
      dio.close();
      header.clear();
      return restValue.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  Future<dynamic> getApi(String url, {String? baseUrl}) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restGet = await dio.get(url);
      dio.close();
      return restGet.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  static Future<dynamic> getApiWithHeaders(
    String url,
    Map<String, dynamic> header, {
    String? baseUrl,
  }) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restGet = await dio.get(url, options: Options(headers: header));
      dio.close();
      header.clear();
      return restGet.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  Future<dynamic> putApi(String url, dynamic formData, {String? baseUrl}) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restValue = await dio.put(url, data: formData);
      dio.close();
      return restValue.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  static Future<dynamic> putApiWithHeaders(
    String url,
    dynamic body,
    Map<String, dynamic> header,
      {String? baseUrl}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restValue = await dio.put(
        url,
        data: body,
        options: Options(headers: header),
      );
      dio.close();
      header.clear();
      return restValue.data;
    } on DioException catch (e) {
      debugPrint('e.response: ${e.response}');
      debugPrint('e.message: ${e.response?.data['message']['en']}');
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  Future<dynamic> patchApiWithHeaders(
    String url,
    dynamic body,
    Map<String, dynamic> header,
      {String? baseUrl}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restValue = await dio.patch(
        url,
        data: body,
        options: Options(headers: header),
      );
      dio.close();
      header.clear();
      return restValue.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  Future<dynamic> deleteApiWithHeaders(
    String url,
    Map<String, dynamic> header,
      {String? baseUrl}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 1,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restGet = await dio.delete(
        url,
        options: Options(
          headers: header,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      dio.close();
      header.clear();
      return restGet.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }

  Future<dynamic> deleteApiWithHeadersAndData(
    String url,
    body,
    Map<String, dynamic> header,
      {String? baseUrl,}
  ) async {
    try {
      var dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _baseUrl,
                connectTimeout: const Duration(milliseconds: 500000),
                receiveTimeout: const Duration(milliseconds: 300000),
                responseType: ResponseType.json,
                maxRedirects: 0,
              ),
            )
            ..interceptors.addAll([
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                filter: (options, args) {
                  //  return !options.uri.path.contains('posts');
                  return !args.isResponse || !args.hasUint8ListData;
                },
              ),
            ]);

      Response restGet = await dio.delete(
        url,
        data: body,
        options: Options(headers: header),
      );
      dio.close();
      header.clear();
      return restGet.data;
    } on DioException catch (e) {
      if (e.response != null) {
        Resp resp = Resp.fromJson(e.response?.data);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": resp.message is String
              ? resp.message
              : resp.message['th'] ?? resp.message['en'] ?? Resp.fromJson(resp.message).message,
          "data": e.response?.data,
        };
        return error;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        Map<String, dynamic> error = {
          "code": e.response?.statusCode ?? 400,
          "statusCode": e.response?.statusCode ?? 400,
          "message": e.message,
          "data": e.requestOptions.data,
        };
        return error;
      }
    }
  }
}
