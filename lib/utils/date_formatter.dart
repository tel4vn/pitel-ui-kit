import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(String time) {
    if (time == '') return '';
    var dateLocalTime =
        DateFormat("yyyyy-MM-ddTHH:mm:ssZ").parseUTC(time).toLocal();
    var outputDate = DateFormat("dd/MM/yyyy' 'HH:mm a'").format(dateLocalTime);
    return outputDate;
  }
}
