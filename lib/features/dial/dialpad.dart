import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/pitel/pitel_service.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialPadArguments {
  DialPadArguments();
}

class DialPadWidget extends StatefulWidget {
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
  final DialPadArguments arguments;
  DialPadWidget({Key? key, required this.arguments}) : super(key: key);

  @override
  State<DialPadWidget> createState() => _MyDialPadWidget();
}

class _MyDialPadWidget extends State<DialPadWidget>
    implements SipPitelHelperListener {
  late String _dest;
  PitelCall get pitelCall => widget._pitelCall;
  final TextEditingController _textController = TextEditingController();
  late SharedPreferences _preferences;

  String receivedMsg = 'UNREGISTER';
  PitelClient pitelClient = PitelClient.getInstance();
  String state = '';

  @override
  initState() {
    super.initState();
    state = pitelCall.getRegisterState();
    receivedMsg = 'UNREGISTER';
    _bindEventListeners();
    _loadSettings();
  }

  @override
  void deactivate() {
    super.deactivate();
    _removeEventListeners();
  }

  void goBack() {
    pitelClient.release();
    context.go('/');
  }

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    _dest = _preferences.getString('dest') ?? '';
    _textController.text = _dest;
  }

  void _bindEventListeners() {
    pitelCall.addListener(this);
  }

  void _removeEventListeners() {
    pitelCall.removeListener(this);
  }

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
      _preferences.setString('dest', dest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          padding: const EdgeInsets.all(20),
          width: 360,
          child: Text(
            'STATUS: $receivedMsg',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          )),
      ElevatedButton(
        onPressed: () {
          final sipInfo = SipInfoData.fromJson({
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

          final pitelClient = PitelServiceImpl();
          pitelClient.setExtensionInfo(sipInfo);
        },
        child: const Text("Register"),
      ),
      const SizedBox(height: 20),
      Container(
        color: Colors.amber,
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
    ]);
  }

  @override
  void registrationStateChanged(PitelRegistrationState state) {
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        goBack();
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
      case PitelRegistrationStateEnum.REGISTERED:
        setState(() {
          receivedMsg = 'REGISTERED';
        });
        break;
    }
  }

  @override
  void onNewMessage(PitelSIPMessageRequest msg) {
    //Save the incoming message to DB
    var msgBody = msg.request.body as String;
    setState(() {
      receivedMsg = msgBody;
    });
  }

  @override
  void callStateChanged(String callId, PitelCallState state) {}

  @override
  void transportStateChanged(PitelTransportState state) {}

  @override
  void onCallReceived(String callId) {
    pitelCall.setCallCurrent(callId);
    context.pushNamed(AppRoute.callScreen.name);
  }

  @override
  void onCallInitiated(String callId) {
    pitelCall.setCallCurrent(callId);
    context.pushNamed(AppRoute.callScreen.name);
  }
}
