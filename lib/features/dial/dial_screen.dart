import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/constants/constants.dart';
import 'package:pitel_ui_kit/features/dial/dial_controller.dart';
import 'package:pitel_ui_kit/features/dial/dialpad.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service.dart';
import 'package:pitel_ui_kit/services/storage/storage_service_provider.dart';
import 'package:pitel_ui_kit/styles/app_colors.dart';
import 'package:pitel_ui_kit/styles/app_themes.dart';
import 'package:pitel_ui_kit/utils/pi_extension.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';

class DialScreen extends ConsumerWidget {
  const DialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerStateProvider);
    final storageProvider = ref.read(storageServiceProvider);
    final dialScreenController =
        ref.read(dialScreenControllerProvider.notifier);

    final sipInfoCache = storageProvider.get(SIP_INFO_KEY);
    SipInfoData sipInfoData = SipInfoData.defaultSipInfo();

    if (sipInfoCache != null) {
      sipInfoData =
          SipInfoData.fromJson(json.decode(json.encode(sipInfoCache)));
    }

    if (storageProvider.has(SIP_INFO_KEY) &&
        registerState != PitelRegistrationStateEnum.REGISTERED) {
      dialScreenController.summitQRData(sipInfoData);
    }

    return Scaffold(
      backgroundColor: Colors.grey[20],
      body: DialPadWidget(
        arguments: DialPadArguments(),
      ),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              registerState.convertToString(),
              style: AppTextTheme.T14M.copyWith(color: AppColors.black),
            ),
            Text(
              sipInfoData.displayName,
              style: AppTextTheme.T12M.copyWith(color: AppColors.black),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final sipInfo = SipInfoData.fromJson({
                "authPass": "Tel4vn.com123@",
                "registerServer": "mobile.tel4vn.com",
                "outboundServer": "pbx-mobile.tel4vn.com:50061",
                "userID": 103,
                "authID": 103,
                "accountName": "103",
                "displayName": "103@mobile.tel4vn.com",
                "dialPlan": null,
                "randomPort": null,
                "voicemail": null,
                "wssUrl": "wss://wss-mobile.tel4vn.com:7444",
                "userName": "user3@mobile.tel4vn.com",
                "apiDomain": "https://api-mobile.tel4vn.com"
              });

              final pitelClient = PitelServiceImpl();
              pitelClient.setExtensionInfo(sipInfo);
            },
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }
}
