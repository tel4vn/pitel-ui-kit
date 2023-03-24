import 'package:pitel_ui_kit/exceptions/pitel_generic_error.dart';
import 'package:pitel_ui_kit/services/connection_service/connection_service.dart';
import 'package:pitel_ui_kit/services/logger/system_logger.dart';

class PitelUtils {
  static checkInternetBeforeRequest(
      ConnectionService? connectivityService, SystemLogger? logger) async {
    //Check internet connection before request API
    final isOnlineEither = await connectivityService?.isOnline();
    isOnlineEither?.fold((l) {
      //! HIDE
      // logger?.d('Internet is Unavailable');
      throw const PitelGenericError.noInternetConnection();
    }, (r) {
      //! HIDE
      // logger?.d('Internet is Available');
    });
  }
}
