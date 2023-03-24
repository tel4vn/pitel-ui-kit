import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service_interface.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service_provider.dart';

class QRScreenController extends StateNotifier<AsyncValue<void>> {
  QRScreenController({required this.pitelService})
      : super(const AsyncData(null));
  final PitelService pitelService;

  Future<void> summitQRData(SipInfoData sipInfoData) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return pitelService.setExtensionInfo(sipInfoData);
    });
  }
}

final qrScreenControllerProvider =
    StateNotifierProvider.autoDispose<QRScreenController, AsyncValue<void>>(
        (ref) {
  final pitelService = ref.watch(pitelServiceProvider);

  return QRScreenController(
    pitelService: pitelService,
  );
});
