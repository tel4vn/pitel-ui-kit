import 'dart:async';
import 'package:pitel_ui_kit/configs/configs.dart';
import 'package:pitel_ui_kit/services/logger/logger_provider.dart';
import 'package:pitel_ui_kit/services/logger/system_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TimerService start a interval hearbeat with configs interval
final timerServiceProvider = Provider<TimerService>((ref) {
  return TimerServiceImpl(
      ref.read(loggerServiceProvider), Configs.timerDuration);
});

/// TimerService handler for interval heartbeat request
/// we can start, stop and reset timer service with this interface
abstract class TimerService {
  Stream<int>? tickerListener();
  void startService();
  void stopService();
  void resetService();
}

class TimerServiceImpl extends TimerService {
  StreamController<int>? timer = StreamController.broadcast();
  StreamSubscription<int>? timerSubscription;
  final SystemLogger logger;
  final Duration duration;

  TimerServiceImpl(this.logger, this.duration);

  @override
  Stream<int>? tickerListener() {
    return timer?.stream;
  }

  @override
  void resetService() {
    timer?.close();
    timerSubscription?.cancel();
    timer = StreamController.broadcast();
    timerSubscription = Stream.periodic(duration, (i) => i).listen((value) {
      timer?.sink.add(value);
      logger.d('value: $value, time: ${DateTime.now()}');
    });
  }

  @override
  void startService() {
    timer = StreamController.broadcast();
    timerSubscription = Stream.periodic(duration, (i) => i).listen((value) {
      timer?.sink.add(value);
      logger.d('value: $value, time: ${DateTime.now()}');
    });
  }

  @override
  void stopService() {
    timer?.close();
    timerSubscription?.cancel();
  }
}
