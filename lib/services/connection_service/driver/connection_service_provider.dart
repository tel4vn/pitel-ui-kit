import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/connection_service/connection_service.dart';
import 'package:pitel_ui_kit/services/connection_service/connection_service_impl.dart';
import 'package:pitel_ui_kit/services/connection_service/driver/flutter_connectivity_driver.dart';

final conenctivityProvider = Provider<FlutterConnectivityDriver>((ref) {
  return FlutterConnectivityDriver(connectivity: Connectivity());
});
 
final conenctionServiceProvider = Provider<ConnectionService>((ref) {
  final connectionDriver =  ref.watch(conenctivityProvider);
  return ConnectionServiceImpl(driver: connectionDriver);
});
 