import 'package:flutter/material.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotifAndroid.initFirebase(DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}
