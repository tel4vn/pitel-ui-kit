import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:plugin_pitel/flutter_pitel_voip.dart';

final callStateController =
    StateProvider<PitelCallStateEnum>((ref) => PitelCallStateEnum.NONE);
final pitelSettingProvider = StateProvider<PitelSettings?>((ref) => null);

class HomeScreen extends ConsumerStatefulWidget {
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;

  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends ConsumerState<HomeScreen> {
  PitelCall get pitelCall => widget._pitelCall;
  final TextEditingController _textController = TextEditingController();

  String receivedMsg = 'UNREGISTER';
  PitelClient pitelClient = PitelClient.getInstance();
  final pitelService = PitelServiceImpl();

  String state = '';
  bool isLogin = false;

  @override
  initState() {
    super.initState();
    state = pitelCall.getRegisterState();
    receivedMsg = 'UNREGISTER';
    _getDeviceToken();
  }

  void _getDeviceToken() async {
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  // ACTION: call device if register success
  // Flow: Register (with sipInfoData) -> Register success REGISTERED -> Start Call
  void _handleCall(BuildContext context, [bool voiceonly = false]) {
    var dest = _textController.text;
    if (dest.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Target is empty.'),
            content: Text('Please enter a SIP URI or username!'),
          );
        },
      );
    } else {
      pitelClient.call(dest, voiceonly).then((value) =>
          value.fold((succ) => {}, (err) => {receivedMsg = err.toString()}));
    }
  }

  void goBack() {
    pitelClient.release();
    context.go('/');
  }

  void _logout() {
    setState(() {
      isLogin = false;
      receivedMsg = 'UNREGISTER';
    });
    _removeDeviceToken();
    pitelCall.unregister();
  }

  // Register Device token when SIP register success (state REGISTER)
  void _registerDeviceToken() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
    final fcmToken = await PushVoipNotif.getFCMToken();

    final response = await pitelClient.registerDeviceToken(
      deviceToken: deviceTokenRes,
      platform: Platform.isIOS ? 'ios' : 'android',
      bundleId: packageInfo.packageName,
      domain: sipInfoData.registerServer,
      extension: sipInfoData.userID.toString(),
      appMode: kReleaseMode ? 'production' : 'dev',
      fcmToken: fcmToken,
    );
  }

  // Remove Device token when user logout (state UNREGISTER)
  void _removeDeviceToken() async {
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();

    final response = await pitelClient.removeDeviceToken(
      deviceToken: deviceTokenRes,
      domain: sipInfoData.registerServer,
      extension: sipInfoData.userID.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pitel UI Kit"),
        centerTitle: true,
      ),
      body: PitelVoipCall(
        goBack: () => context.go('/'),
        goToCall: () => context.pushNamed(AppRoute.callPage.name),
        onCallState: (callState) {
          ref.read(callStateController.notifier).state = callState;
        },
        onRegisterState: (String registerState) {
          setState(() {
            receivedMsg = registerState;
          });
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.all(20),
              width: 360,
              child: Text(
                'STATUS: $receivedMsg',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )),
          isLogin
              ? TextButton(
                  onPressed: _logout,
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
              : ElevatedButton(
                  onPressed: () async {
                    // SIP INFO DATA: input Sip info config data
                    final PackageInfo packageInfo =
                        await PackageInfo.fromPlatform();
                    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
                    final fcmToken = await PushVoipNotif.getFCMToken();

                    final pnPushParams = PnPushParams(
                      pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
                      pnParam: Platform.isAndroid
                          ? packageInfo.packageName
                          : '${TEAM_ID}.${packageInfo.packageName}.voip',
                      pnPrid: deviceTokenRes,
                      fcmToken: fcmToken,
                    );
                    final pitelClient = PitelServiceImpl();
                    final pitelSettingRes = await pitelClient.setExtensionInfo(
                        sipInfoData, pnPushParams);
                    ref.read(pitelSettingProvider.notifier).state =
                        pitelSettingRes;
                    setState(() {
                      isLogin = true;
                    });
                    _registerDeviceToken();
                  },
                  child: const Text("Register"),
                ),
          const SizedBox(height: 20),
          Container(
            color: Colors.green,
            child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input Phone number",
                  hintStyle: TextStyle(fontSize: 18)),
              controller: _textController,
              showCursor: true,
              autofocus: true,
            ),
          ),
          const SizedBox(height: 20),
          receivedMsg == "REGISTERED"
              ? ElevatedButton(
                  onPressed: () => _handleCall(context, true),
                  child: const Text("Call"))
              : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
