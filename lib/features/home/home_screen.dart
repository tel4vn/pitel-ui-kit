import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:pitel_ui_kit/constants/constants.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_callkit_incoming_timer/flutter_callkit_incoming.dart';

class HomeScreen extends StatefulWidget {
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends State<HomeScreen> {
  PitelCall get pitelCall => widget._pitelCall;
  PitelClient pitelClient = PitelClient.getInstance();

  String receivedMsg = 'UNREGISTER';
  bool isLogin = false;

  final TextEditingController _textController = TextEditingController();

  /// Initialize state, get device token, request permission, and cache SharedPreferences
  @override
  initState() {
    super.initState();
    receivedMsg = 'UNREGISTER';
    _getDeviceToken();
    _requestFullIntentPermission();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  /// Dispose TextEditingController when the widget is destroyed
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Request full intent permission for Android (CallKit)
  void _requestFullIntentPermission() async {
    if (Platform.isAndroid) {
      await FlutterCallkitIncoming.requestFullIntentPermission();
    }
  }

  // Get device token
  void _getDeviceToken() async {
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
    debugPrint('deviceTokenRes: $deviceTokenRes');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool("IS_LOGGED_IN");
    if (isLoggedIn != null && isLoggedIn) {
      setState(() {
        receivedMsg = 'REGISTERED';
        isLogin = true;
      });
    }
  }

  /// Get push notification configuration info (teamId, bundleId)
  Future<PushNotifParams> _getPushNotifParams() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return PushNotifParams(
      teamId: APPLE_TEAM_ID,
      bundleId: packageInfo.packageName, // Use your app bundle ID
    );
  }

  /// Logout SIP account and update login state
  void _logout() async {
    setState(() {
      isLogin = false;
      receivedMsg = 'UNREGISTER';
    });
    final PushNotifParams pushNotifParams = await _getPushNotifParams();

    final res = await pitelClient.logoutExtension(
      sipInfoData: sipInfoData,
      pushNotifParams: pushNotifParams,
    );
    setState(() {
      receivedMsg = res;
    });
    // Set isLoggedIn = false when user logout
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IS_LOGGED_IN", false);
  }

  /// Register SIP extension and save config to provider
  void _handleRegister({required bool shouldRegisterDeviceToken}) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    PitelClient pitelClient = PitelClient.getInstance();

    final PushNotifParams pushNotifParams = PushNotifParams(
      teamId: APPLE_TEAM_ID,
      bundleId: packageInfo.packageName,
    );
    await pitelClient.registerExtension(
        sipInfoData: sipInfoData,
        pushNotifParams: pushNotifParams,
        appMode: 'dev',
        shouldRegisterDeviceToken: shouldRegisterDeviceToken);
  }

  /// Callback when SIP registration state changes
  void _onRegisterState(String registerState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (registerState == 'REGISTERED') {
      //  Set isLoggedIn = true when user logout
      prefs.setBool("IS_LOGGED_IN", true);

      setState(() {
        receivedMsg = registerState;
        isLogin = true;
      });
    }
  }

  // ACTION: call device if register success
  // Flow: Register (with sipInfoData) -> Register success REGISTERED -> Start Call
  /// Handle outgoing call, validate input and make the call
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
      // Make call outgoing
      pitelCall.outGoingCall(
        phoneNumber: dest,
        handleRegister: () => _handleRegister(shouldRegisterDeviceToken: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pitel SDK Demo"),
        centerTitle: true,
      ),
      body: PitelVoipCall(
        goBack: () => context.go('/'),
        goToCall: () {
          FocusScope.of(context).unfocus();
          context.pushNamed(AppRoute.callPage.name);
        },
        onCallState: (callState) {},
        onRegisterState: (String registerState) {
          _onRegisterState(registerState);
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
                  onPressed: () =>
                      _handleRegister(shouldRegisterDeviceToken: true),
                  child: const Text("Register"),
                ),
          const SizedBox(height: 20),
          Container(
            color: Colors.blue[200],
            child: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input Phone number",
                  hintStyle: TextStyle(fontSize: 18)),
              controller: _textController,
              // showCursor: true,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => _handleCall(context, true),
              child: const Text("Call")),
        ]),
      ),
    );
  }
}
