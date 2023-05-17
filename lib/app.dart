import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:plugin_pitel/component/app_life_cycle/app_life_cycle.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/models/pn_push_params.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import 'package:plugin_pitel/voip_push/voip_notif.dart';

final sipInfoData = SipInfoData.fromJson({
  "authPass": "${Password}",
  "registerServer": "${Domain}",
  "outboundServer": "${Outbound Proxy}",
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  bool isCall = false;

  @override
  void initState() {
    super.initState();
    VoipNotifService.listenerEvent(
      callback: (event) {},
      onCallAccept: () {
        //! Re-register when user accept call
        handleRegister();
      },
      onCallDecline: () {},
      onCallEnd: () {
        pitelCall.hangup();
      },
    );
    initRegister();
  }

  void initRegister() async {
    isCall = true;
    final List<dynamic> res = await FlutterCallkitIncoming.activeCalls();
    if (Platform.isAndroid) {
      handleRegister();
    }
    if (res.isEmpty && Platform.isIOS) {
      handleRegister();
    }
  }
  
  void handleRegister() async {
    final pnPushParams = PnPushParams(
      pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
      pnParam: Platform.isAndroid
          ? '${bundleId}'                        // Example com.company.app
          : '${apple_team_id}.${bundleId}.voip', // Example com.company.app
      pnPrid: '${deviceToken}', 
    );
    pitelService.setExtensionInfo(sipInfoData, pnPushParams);
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = router;
    return AppLifecycleTracker(
      didChangeAppState: (state) async {
        if (Platform.isIOS) {
          final List<dynamic> res = await FlutterCallkitIncoming.activeCalls();
          if (state == AppState.resumed && res.isEmpty) {
            if (!isCall) {
              handleRegister();
            }
          }
          if (state == AppState.inactive || state == AppState.paused) {
            setState(() {
              isCall = false;
            });
          }
        }
        if (Platform.isAndroid && state == AppState.resumed) {
          if (!pitelCall.isConnected) {
            handleRegister();
          }
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
}
