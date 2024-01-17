import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitel_ui_kit/app.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String receivedMsg = 'UNREGISTER';
  String state = '';
  bool isLogin = false;

  final TextEditingController _textController = TextEditingController();

  @override
  initState() {
    super.initState();
    state = pitelCall.getRegisterState();
    receivedMsg = 'UNREGISTER';
    _getDeviceToken();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void _getDeviceToken() async {
    final deviceTokenRes = await PushVoipNotif.getDeviceToken();
  }

  void _logout() async {
    setState(() {
      isLogin = false;
      receivedMsg = 'UNREGISTER';
    });
    pitelClient.logoutExtension(sipInfoData);
    // Set isLoggedIn = false when user logout
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IS_LOGGED_IN", false);
  }

  void _handleRegister() async {
    // SIP INFO DATA: input Sip info config data
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final PushNotifParams pushNotifParams = PushNotifParams(
      teamId: '${apple_team_id}',
      bundleId: packageInfo.packageName,
    );

    final pitelClient = PitelServiceImpl();
    final pitelSettingRes =
        await pitelClient.setExtensionInfo(sipInfoData, pushNotifParams);
    ref.read(pitelSettingProvider.notifier).state = pitelSettingRes;
  }

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

  void _handleRegisterCall() async {
    final PitelSettings? pitelSetting = ref.watch(pitelSettingProvider);
    if (pitelSetting != null) {
      pitelCall.register(pitelSetting);
    } else {
      registerFunc();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("ACCEPT_CALL", true);
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
        goToCall: () => context.pushNamed(AppRoute.callPage.name),
        onCallState: (callState) {
          ref.read(callStateController.notifier).state = callState;
        },
        onRegisterState: (String registerState) {
          _onRegisterState(registerState);
        },
        bundleId: '${bundle_id}',
        sipInfoData: sipInfoData,
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
              showCursor: true,
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
