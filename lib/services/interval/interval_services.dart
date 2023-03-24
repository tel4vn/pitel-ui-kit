import 'dart:async';

class IntervalServices {
  late final Stream<int> interval;
  final Duration duration;

  IntervalServices(this.duration) {
    interval = Stream<int>.periodic(duration, (count) => count);
  }

  void resetIntervalWithDuration(Duration duration) {
    interval = Stream<int>.periodic(duration);
  }
}
