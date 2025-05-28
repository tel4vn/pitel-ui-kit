import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'features/home/home_screen.dart';

// Extension 1
final sipInfoDataExt1 = SipInfoData.fromJson({
  "authPass": "${Password}",
  "registerServer": "${Domain}",
  "outboundServer": "${Outbound Proxy}",
  "port": PORT,
  "accountName": "${UUser}",      // Example 101
  "displayName": "${UUser}@${Domain}",
  "wssUrl": "${URL WSS}",
});

// Extension 2
final sipInfoDataEx2 = SipInfoData.fromJson({
  "authPass": "${Password}",
  "registerServer": "${Domain}",
  "outboundServer": "${Outbound Proxy}",
  "port": PORT,
  "accountName": "${UUser}",      // Example 101
  "displayName": "${UUser}@${Domain}",
  "wssUrl": "${URL WSS}",
});

/// Note: sipInfoDataExt1 is data for Extension 1, sipInfoDataEx2 is data for Extension 2.
/// Condition in the example just for developer support test.
/// Replace your condition logic in here.
final sipInfoData = Platform.isIOS ? sipInfoDataExt1 : sipInfoDataEx2;

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

    final PushNotifParams pushNotifParams = PushNotifParams(
      teamId: '${apple_team_id}',
      bundleId: packageInfo.packageName,
    );

    final pitelClient = PitelServiceImpl();
    final pitelSetting =
        await pitelClient.setExtensionInfo(sipInfoData, pushNotifParams);
    ref.read(pitelSettingProvider.notifier).state = pitelSetting;
  }

  void handleRegister() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool("IS_LOGGED_IN");

    if (isLoggedIn != null && isLoggedIn) {
      registerFunc();
    }
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
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        onGenerateTitle: (BuildContext context) => 'My Pitel',
        themeMode: ThemeMode.light,
        theme: ThemeData(primaryColor: Colors.green),
        builder: EasyLoading.init(),
      ),
    );
  }
}
