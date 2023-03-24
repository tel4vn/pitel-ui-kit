import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service_interface.dart';

final pitelServiceProvider = Provider<PitelService>((ref) {
  return PitelServiceImpl();
});