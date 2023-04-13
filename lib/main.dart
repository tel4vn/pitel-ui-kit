import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:plugin_pitel/voip_push/firebase_options.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotifAndroid.initFirebase(DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
