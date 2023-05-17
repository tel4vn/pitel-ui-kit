import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:plugin_pitel/flutter_pitel_voip.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

const String deviceToken = '';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements SipPitelHelperListener {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  String registerStatus = "UNREGISTERED";

  @override
  void initState() {
    super.initState();
    VoipNotifService.listenerEvent(
      callback: (event) {},
      onCallAccept: () {
        //! Re-register when user accept call
        handleRegisterCall();
      },
      onCallDecline: () {},
      onCallEnd: () {
        pitelCall.hangup();
      },
    );
  }

  void handleRegisterCall() async {
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
    handleRegisterCall();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = router;
    return AppLifecycleTracker(
      //! Re-Register when resumed/open app in Android
      didChangeAppState: (state) {
        if (Platform.isAndroid && state == AppState.opened) {
          handleRegister();
        }
        if (Platform.isIOS && state == AppState.resumed) {
          handleRegister();
        }
      },
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

  @override
  void callStateChanged(String callId, PitelCallState state) {}

  @override
  void onCallInitiated(String callId) {}

  @override
  void onCallReceived(String callId) {}

  @override
  void onNewMessage(PitelSIPMessageRequest msg) {}

  @override
  void registrationStateChanged(PitelRegistrationState state) {
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        break;
      case PitelRegistrationStateEnum.NONE:
        break;
      case PitelRegistrationStateEnum.UNREGISTERED:
        // ref.read(registerStateController.notifier).state = 'UNREGISTERED';
        setState(() {
          registerStatus = "UNREGISTERED";
        });
        break;
      case PitelRegistrationStateEnum.REGISTERED:
        setState(() {
          registerStatus = "REGISTERED";
        });
        // ref.read(registerStateController.notifier).state = 'REGISTERED';
        break;
    }
  }

  @override
  void transportStateChanged(PitelTransportState state) {}
}
