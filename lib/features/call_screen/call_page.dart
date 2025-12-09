import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/features/home/home_screen.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';

/// CallPage displays the call UI and manages call state using Riverpod
class CallPage extends ConsumerWidget {
  const CallPage({super.key});

  /// Build the call screen and connect it to the call state provider
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current call state from Riverpod provider
    final callState = ref.watch(callStateController);

    return CallScreen(
      callState: callState,
      // Callback to update call state in provider when it changes
      onCallState: (PitelCallStateEnum res) {
        ref.read(callStateController.notifier).state = res;
      },
      bgColor: Colors.cyan,
      txtWaiting: 'Connecting...',
    );
  }
}
