import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service_interface.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service_provider.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';

final receivedMsgProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final registerStateProvider =
    StateProvider.autoDispose<PitelRegistrationStateEnum>((ref) {
  return PitelRegistrationStateEnum.UNREGISTERED;
});

class DialScreenController extends StateNotifier<AsyncValue<void>> {
  DialScreenController({required this.pitelService})
      : super(const AsyncData(null));
  final PitelService pitelService;

  Future<void> summitQRData(SipInfoData sipInfoData) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return pitelService.setExtensionInfo(sipInfoData);
    });
  }
}

final dialScreenControllerProvider =
    StateNotifierProvider.autoDispose<DialScreenController, AsyncValue<void>>(
        (ref) {
  final pitelService = ref.watch(pitelServiceProvider);
  return DialScreenController(
    pitelService: pitelService,
  );
});
