import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/storage/hive_storage_service.dart';
import 'package:pitel_ui_kit/services/storage/storage_service.dart';

final storageServiceProvider = Provider<StorageService>(
  (_) => HiveStorageService(),
);
