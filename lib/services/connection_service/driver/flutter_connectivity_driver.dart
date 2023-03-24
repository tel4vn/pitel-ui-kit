
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pitel_ui_kit/services/connection_service/driver/connection_driver.dart';

class FlutterConnectivityDriver implements ConnectionDriver {
  final Connectivity connectivity;

  FlutterConnectivityDriver({required this.connectivity});

  @override
  Future<bool> get isOnline async {
    final result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile;
  }

  @override
  Stream<bool> get listenConnectionStatus {
  return  connectivity.onConnectivityChanged.map((event) => event == ConnectivityResult.wifi ||
        event == ConnectivityResult.mobile);
  }


}
