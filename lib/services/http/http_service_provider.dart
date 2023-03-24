import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/http/dio_http_service.dart';
import 'package:pitel_ui_kit/services/http/http_service.dart';
import 'package:pitel_ui_kit/services/storage/storage_service_provider.dart';

final httpServiceProvider = Provider<HttpService>((ref) {
  final storageService = ref.watch(storageServiceProvider);

  return DioHttpService(storageService, enableCaching: false);
});
 
 final httpServiceProviderCaching = Provider<HttpService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return DioHttpService(storageService, enableCaching: true);
});