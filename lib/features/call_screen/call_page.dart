import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plugin_pitel/flutter_pitel_voip.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CallScreen(
      goBack: () {
        context.pop();
      },
      bgColor: Colors.cyan,
    );
  }
}
