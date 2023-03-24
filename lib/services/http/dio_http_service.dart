import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pitel_ui_kit/configs/configs.dart';
import 'package:pitel_ui_kit/constants/constants.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/http/dio-interceptors/cache_interceptor.dart';
import 'package:pitel_ui_kit/services/http/http_service.dart';
import 'package:pitel_ui_kit/services/logger/system_logger.dart';
import 'package:pitel_ui_kit/services/storage/storage_service.dart';

class DioHttpService implements HttpService {
  final StorageService storageService;

  late final Dio dio;
  final logger = SystemLogger();

  DioHttpService(
    this.storageService, {
    Dio? dioOverride,
    bool enableCaching = false,
  }) {
    dio = dioOverride ?? Dio(_getAuthentication());
    if (enableCaching) {
      dio.interceptors.add(CacheInterceptor(storageService));
    }
  }

  BaseOptions _getAuthentication() {
    final sipInfoCache = storageService.get(SIP_INFO_KEY);
    SipInfoData sipInfoData = SipInfoData.defaultSipInfo();

    if (sipInfoCache != null) {
      sipInfoData =
          SipInfoData.fromJson(json.decode(json.encode(sipInfoCache)));
    }

    final tokenString = '${sipInfoData.userName}:${sipInfoData.authPass}';
    final token = base64Encode(utf8.encode(tokenString));

    baseUrl = sipInfoData.apiDomain ?? Configs.apiBaseUrl;

    Map<String, String> headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': 'Basic $token'
    };

    return BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    );
  }

  @override
  String baseUrl = Configs.apiBaseUrl;

  @override
  Map<String, String> headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  BaseOptions get baseOptions => BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      );

  @override
  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? queryParameters,
      bool forceRefresh = false,
      String? customBaseUrl,
      Options? options}) async {
    //! HIDE
    // logger.d("request.data $endpoint");

    dio.options.extra[dioCacheForceRefreshKey] = forceRefresh;

    Response response = await dio.get(endpoint,
        queryParameters: queryParameters, options: options);

    // logger.d("response.data ${response.data}");
    // logger.d("response.statusCode ${response.statusCode}");

    if (response.data == null || response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }

  @override
  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options}) async {
    logger.d("request.data $endpoint");

    Response response = await dio.post(endpoint,
        queryParameters: queryParameters, data: data, options: options);

    logger.d("response.data ${response.data}");
    logger.d("response.statusCode ${response.statusCode}");

    if (response.data == null || response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }

  @override
  Future<dynamic> delete(String endpoint,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options}) async {
    logger.d("request.data $endpoint");

    Response response = await dio.delete(endpoint,
        queryParameters: queryParameters, data: data, options: options);

    logger.d("response.data ${response.data}");
    logger.d("response.statusCode ${response.statusCode}");

    if (response.data == null || response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }

  @override
  Future put(String endpoint,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options}) async {
    logger.d("request.data $endpoint put $data");

    Response response = await dio.put(endpoint,
        queryParameters: queryParameters, data: data, options: options);

    logger.d("response.data ${response.data}");
    logger.d("response.statusCode ${response.statusCode}");

    if (response.data == null || response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }

  @override
  Future getBytes(String endpoint,
      {Map<String, dynamic>? queryParameters,
      bool forceRefresh = false,
      Options? options}) async {
    dio.options.extra[dioCacheForceRefreshKey] = forceRefresh;

    Response<List<int>> response = await dio.get<List<int>>(endpoint,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes));

    if (response.data == null || response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }
}

class HttpException implements Exception {
  final String? title;
  final String? message;
  final int? statusCode;

  HttpException({
    this.title,
    this.message,
    this.statusCode,
  });
}
