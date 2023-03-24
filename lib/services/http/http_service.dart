import 'package:dio/dio.dart';

abstract class HttpService {
  String get baseUrl;

  Map<String, String> get headers;

  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? queryParameters,
      bool forceRefresh = false,
      Options? options});

  Future<dynamic> getBytes(String endpoint,
      {Map<String, dynamic>? queryParameters,
      bool forceRefresh = false,
      Options? options});

  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options});

  Future<dynamic> put(String endpoint,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options});

  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options});
}
