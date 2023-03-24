

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SystemLogger extends Logger {
  SystemLogger()
      : super(
    filter: SystemFilter(), // Use the default LogFilter (-> only log in debug mode)
    printer: PrefixPrinter(PrettyPrinter(colors: false)), // Use the PrettyPrinter to format and print log
    output:
    null, // Use the default LogOutput (-> send everything to console)
  );

}

class SystemFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level == Level.debug ? !kReleaseMode : false;
  }
}


class PrefixPrinter extends LogPrinter {
  final LogPrinter _realPrinter;
  late Map<Level, String> _prefixMap;

  PrefixPrinter(this._realPrinter,
      {debug, verbose, wtf, info, warning, error, nothing}) : super() {
    _prefixMap = {
      Level.debug: debug ?? 'DEBUG',
      Level.verbose: verbose ?? 'VERBOSE',
      Level.wtf: wtf ?? 'WTF',
      Level.info: info ?? 'INFO',
      Level.warning: warning ?? 'WARNING',
      Level.error: error ?? 'ERROR',
      Level.nothing: nothing ?? 'NOTHING',
    };
  }

  @override
  List<String> log(LogEvent event) {
    return _realPrinter.log(event).map((s) => '${_prefixMap[event.level]}$s').toList();
  }
}

class SystemPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message];
  }
}
