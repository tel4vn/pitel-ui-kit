import 'package:flutter/material.dart';
import 'package:pitel_ui_kit/features/dial/dial_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: DialScreen(),
    );
  }
}
