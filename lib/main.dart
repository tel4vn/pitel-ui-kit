import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:pitel_ui_kit/localization/string_hardcoded.dart';
import 'package:pitel_ui_kit/services/storage/hive_storage_service.dart';
import 'package:pitel_ui_kit/services/storage/storage_service.dart';
import 'package:pitel_ui_kit/services/storage/storage_service_provider.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
    await Hive.initFlutter();
    final StorageService initializedStorageService = HiveStorageService();
    await initializedStorageService.init();

    // * Entry point of the app
    runApp(ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(initializedStorageService),
      ],
      child: const MyApp(),
    ));

    // * This code will present some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    // * Log any errors to console
    debugPrint(error.toString());
  });
}
