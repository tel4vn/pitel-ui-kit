import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/logger/system_logger.dart';

final loggerServiceProvider = Provider<SystemLogger>((ref) {
  return SystemLogger();
});