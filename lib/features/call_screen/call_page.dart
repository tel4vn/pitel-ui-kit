import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitel_ui_kit/features/home/home_screen.dart';
import 'package:plugin_pitel/flutter_pitel_voip.dart';

class CallPage extends ConsumerWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callStateController);
    return CallScreen(
      callState: callState,
      goBack: () {
        context.pop();
      },
      bgColor: Colors.cyan,
    );
  }
}
