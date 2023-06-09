import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:plugin_pitel/flutter_pitel_voip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/home/home_screen.dart';

final sipInfoData = SipInfoData.fromJson({
  "authPass": "${Password}",
  "registerServer": "${Domain}",
  "outboundServer": "${Outbound Proxy}",
  'port': PORT,
  "userID": UUser,                // Example 101
  "authID": UUser,                // Example 101
  "accountName": "${UUser}",      // Example 101
  "displayName": "${UUser}@${Domain}",
  "dialPlan": null,
  "randomPort": null,
  "voicemail": null,
  "wssUrl": "${URL WSS}",
  "userName": "${username}@${Domain}",
  "apiDomain": "${URL API}"
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  void registerFunc() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
    final fcmToken = await PushVoipNotif.getFCMToken();

    final pnPushParams = PnPushParams(
      pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
      pnParam: Platform.isAndroid
          ? '${bundleId}'                         // Example com.company.app
          : '${apple_team_id}.${bundleId}.voip',  // Example com.company.app
      pnPrid: deviceTokenRes,
      fcmToken: fcmToken,
    );

    final pitelSetting = await pitelService.setExtensionInfo(sipInfoData, pnPushParams);
    ref.read(pitelSettingProvider.notifier).state = pitelSetting;

  }

  void handleRegister() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? registerState = prefs.getString("REGISTER_STATE");

    if (registerState == "REGISTERED") return;
    registerFunc();
  }
  
  void handleRegisterCall() async {
    final PitelSettings? pitelSetting = ref.watch(pitelSettingProvider);
    if (pitelSetting != null) {
      pitelCall.register(pitelSetting);
    } else {
      registerFunc();
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = router;
    return PitelVoip(
      handleRegister: handleRegister,
      handleRegisterCall: handleRegisterCall,
      child: MaterialApp.router(
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        onGenerateTitle: (BuildContext context) => 'My Pitel',
        themeMode: ThemeMode.light,
        theme: ThemeData(primaryColor: Colors.green),
      ),
    );
  }
}