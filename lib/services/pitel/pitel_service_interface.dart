import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';

abstract class PitelService {
  Future<void> setExtensionInfo(SipInfoData sipInfoData);
  bool registerSipWithoutFCM();
}