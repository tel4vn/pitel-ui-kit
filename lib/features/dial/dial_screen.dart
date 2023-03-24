import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/features/dial/dial_controller.dart';
import 'package:pitel_ui_kit/features/dial/dialpad.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service.dart';
import 'package:pitel_ui_kit/styles/app_colors.dart';
import 'package:pitel_ui_kit/styles/app_themes.dart';
import 'package:pitel_ui_kit/utils/pi_extension.dart';

class DialScreen extends ConsumerWidget {
  const DialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerStateProvider);

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
            // Text(
            //   sipInfoData.displayName,
            //   style: AppTextTheme.T12M.copyWith(color: AppColors.black),
            // )
          ],
        ),
        centerTitle: true,
      ),
    );
  }
}
