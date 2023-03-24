import 'package:flutter/material.dart';
import 'package:pitel_ui_kit/features/dial/dialpad.dart';

class DialScreen extends StatelessWidget {
  const DialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[20],
      body: DialPadWidget(
        arguments: DialPadArguments(),
      ),
      appBar: AppBar(
        title: const Text("Pitel UI Kit"),
        centerTitle: true,
      ),
    );
  }
}
