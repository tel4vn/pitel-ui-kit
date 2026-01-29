import 'package:flutter/material.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CallScreen(
      bgColor: Colors.cyan,
      txtWaiting: 'Waiting...',
      showHoldCall: true,
    );
  }
}
