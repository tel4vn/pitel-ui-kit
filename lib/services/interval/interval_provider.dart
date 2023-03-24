import 'package:pitel_ui_kit/services/interval/interval_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final intervalProvider = StreamProvider<int>((ref) {
  return IntervalServices(const Duration(seconds: 2)).interval;
});