import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';
import 'package:is_lock_screen/is_lock_screen.dart';

final checkIsPushNotif = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;

  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _MyHomeScreen();
}

class _MyHomeScreen extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver
    implements SipPitelHelperListener {
  // late String _dest;
  PitelCall get pitelCall => widget._pitelCall;
  final TextEditingController _textController = TextEditingController();

  String receivedMsg = 'UNREGISTER';
  PitelClient pitelClient = PitelClient.getInstance();
  final pitelService = PitelServiceImpl();

  String state = '';
  bool isLogin = false;
  bool lockScreen = false;

  // INIT: Initialize state
  @override
  initState() {
    super.initState();
    state = pitelCall.getRegisterState();
    receivedMsg = 'UNREGISTER';
    _bindEventListeners();
    _getDeviceToken();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      final isLock = await isLockScreen();
      setState(() {
        lockScreen = isLock ?? false;
      });
    }
  }

  void _getDeviceToken() async {
    final deviceToken = await PushVoipNotif.getDeviceToken();
    print(deviceToken);
  }

  @override
  void deactivate() {
    super.deactivate();
    _removeEventListeners();
  }

  void _bindEventListeners() {
    pitelCall.addListener(this);
  }

  void _removeEventListeners() {
    pitelCall.removeListener(this);
  }

  // HANDLE: handle message if register status change
  @override
  void onNewMessage(PitelSIPMessageRequest msg) {
    var msgBody = msg.request.body as String;
    setState(() {
      receivedMsg = msgBody;
    });
  }

  @override
  void callStateChanged(String callId, PitelCallState state) {
    if (state.state == PitelCallStateEnum.ENDED && lockScreen) {
      FlutterCallkitIncoming.endAllCalls();
    }
  }

  @override
  void transportStateChanged(PitelTransportState state) {}

  @override
  void onCallReceived(String callId) {
    pitelCall.setCallCurrent(callId);
    if (Platform.isIOS) {
      pitelCall.answer();
    }
    if (Platform.isAndroid) {
      context.pushNamed(AppRoute.callScreen.name);
    }
    if (!lockScreen) {
      context.pushNamed(AppRoute.callScreen.name);
    }
  }

  @override
  void onCallInitiated(String callId) {
    pitelCall.setCallCurrent(callId);
    context.pushNamed(AppRoute.callScreen.name);
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
    final response = await pitelClient.registerDeviceToken(
      deviceToken: "${device_token}",
      platform: '${platform}',          // android or ios
      bundleId: '${bundle_id}',         // Example: com.pitel.uikit.demo
      domain: '${Domain}',
      extension: '${UUser}',
      appMode: kReleaseMode ? 'production' : 'dev',
    );
  }
  
  // Remove Device token when user logout (state UNREGISTER)
  void _removeDeviceToken() async {
    final response = await pitelClient.removeDeviceToken(
      deviceToken: '${device_token}',
      domain: '${Domain}',
      extension: '${UUser}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pitel UI Kit"),
        centerTitle: true,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            padding: const EdgeInsets.all(20),
            width: 360,
            child: Text(
              'STATUS: $receivedMsg',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
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
                onPressed: () {
                  // SIP INFO DATA: input Sip info config data
                  final pitelClient = PitelServiceImpl();
                  pitelClient.setExtensionInfo(sipInfoData);
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
    );
  }

  // STATUS: check register status
  @override
  void registrationStateChanged(PitelRegistrationState state) {
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        goBack();
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
        setState(() {
          receivedMsg = 'UNREGISTERED';
        });
        break;
      case PitelRegistrationStateEnum.REGISTERED:
        setState(() {
          receivedMsg = 'REGISTERED';
        });
        break;
    }
  }
}
