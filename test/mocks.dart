
import 'package:mocktail/mocktail.dart';
import 'package:pitel_ui_kit/services/connection_service/connection_service.dart';
import 'package:pitel_ui_kit/services/local_storage/local_store.dart';
import 'package:pitel_ui_kit/services/logger/system_logger.dart';
import 'package:pitel_ui_kit/services/storage/storage_service.dart';

class MockLocalStorageService extends Mock implements LocalStorage {}

class MockStorageService extends Mock implements StorageService {}

class MockConnectionService extends Mock implements ConnectionService {}

class MockSystemLogger extends Mock implements SystemLogger {}

