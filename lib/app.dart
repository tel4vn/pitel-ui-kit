import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:plugin_pitel/flutter_pitel_voip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/home/home_screen.dart';

// final sipInfoData = SipInfoData.fromJson({
//   "authPass": "${Password}",
//   "registerServer": "${Domain}",
//   "outboundServer": "${Outbound Proxy}",
//   "userID": UUser,                // Example 101
//   "authID": UUser,                // Example 101
//   "accountName": "${UUser}",      // Example 101
//   "displayName": "${UUser}@${Domain}",
//   "dialPlan": null,
//   "randomPort": null,
//   "voicemail": null,
//   "wssUrl": "${URL WSS}",
//   "userName": "${username}@${Domain}",
//   "apiDomain": "${URL API}"
// });

final sipInfoData = SipInfoData.fromJson({
  "authPass": "Tel4vn.com123@",
  "registerServer": "mobile.tel4vn.com",
  "outboundServer": "pbx-mobile.tel4vn.com:50061",
  'port': 50061,
  "userID": 103,
  "authID": 103,
  "accountName": "103",
  "displayName": "103@mobile.tel4vn.com",
  "dialPlan": null,
  "randomPort": null,
  "voicemail": null,
  "wssUrl": "wss://wss-mobile.tel4vn.com:7444",
  "userName": "user3@mobile.tel4vn.com",
  "apiDomain": "https://api-mobile.tel4vn.com"
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;
  bool haveCall = false;

  void registerFunc() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
    final fcmToken = await PushVoipNotif.getFCMToken();

    final pnPushParams = PnPushParams(
      pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
      pnParam: Platform.isAndroid
          ? packageInfo.packageName
          : 'XP2BMU4626.${packageInfo.packageName}.voip',
      pnPrid: deviceTokenRes,
      fcmToken: fcmToken,
    );

    pitelService.setExtensionInfo(sipInfoData, pnPushParams);
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
