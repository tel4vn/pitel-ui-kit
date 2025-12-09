import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/constants/constants.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_callkit_incoming_timer/flutter_callkit_incoming.dart';

// Config your state management in here
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
  PitelClient pitelClient = PitelClient.getInstance();
  final pitelService = PitelServiceImpl();
  SharedPreferences? _prefs;

  String registerStatus = 'UNREGISTER';
  bool isLogin = false;

  final TextEditingController _textController = TextEditingController();

  /// Initialize state, get device token, request permission, and cache SharedPreferences
  @override
  initState() {
    super.initState();
    registerStatus = 'UNREGISTER';
    _initPrefs();
    _getDeviceToken();
    _requestFullIntentPermission();
  }

  /// Initialize SharedPreferences to cache login state
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
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

  /// Get device token and check login state
  void _getDeviceToken() async {
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
    debugPrint('deviceTokenRes: $deviceTokenRes');
    final isLoggedIn = _prefs?.getBool("IS_LOGGED_IN");
    if (isLoggedIn != null && isLoggedIn) {
      setState(() {
        registerStatus = 'REGISTERED';
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
    final PushNotifParams pushNotifParams = await _getPushNotifParams();
    await pitelClient.logoutExtension(
      sipInfoData: sipInfoData,
      pushNotifParams: pushNotifParams,
    );

    if (mounted) {
      setState(() {
        isLogin = false;
        registerStatus = 'UNREGISTER';
      });
    }
    // Set isLoggedIn = false when user logout
    await _prefs?.setBool("IS_LOGGED_IN", false);
  }

  /// Register SIP extension and save config to provider
  void _handleRegister() async {
    final PushNotifParams pushNotifParams = await _getPushNotifParams();

    final pitelClient = PitelServiceImpl();
    final pitelSettingRes =
        await pitelClient.setExtensionInfo(sipInfoData, pushNotifParams);
    ref.read(pitelSettingProvider.notifier).state = pitelSettingRes;
  }

  /// Register extension if not available, then register SIP
  void _handleRegisterCall() async {
    final PitelSettings? pitelSetting = ref.read(pitelSettingProvider);
    if (pitelSetting != null) {
      pitelCall.register(pitelSetting);
    } else {
      _handleRegister();
    }
  }

  /// Callback when SIP registration state changes
  void _onRegisterState(String registerState) async {
    if (registerState == 'REGISTERED') {
      //  Set isLoggedIn = true when user logout
      _prefs?.setBool("IS_LOGGED_IN", true);

      setState(() {
        registerStatus = registerState;
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
        handleRegisterCall: _handleRegisterCall,
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
          FocusScope.of(context).unfocus(); // Dismiss keyboard
          context.pushNamed(AppRoute.callPage.name);
        },
        onCallState: (callState) {
          ref.read(callStateController.notifier).state = callState;
        },
        onRegisterState: (String registerState) {
          _onRegisterState(registerState);
        },
        bundleId: BUNDLE_ID,
        sipInfoData: sipInfoData,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.all(20),
              width: 360,
              child: Text(
                'STATUS: $registerStatus',
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
                  onPressed: _handleRegister,
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
            ),
          ),
          const SizedBox(height: 20),
          registerStatus == "REGISTERED"
              ? ElevatedButton(
                  onPressed: () => _handleCall(context, true),
                  child: const Text("Call"))
              : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
