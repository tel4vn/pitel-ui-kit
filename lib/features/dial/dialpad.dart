import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitel_ui_kit/common_widgets/action_button.dart';
import 'package:pitel_ui_kit/features/dial/dial_controller.dart';
import 'package:pitel_ui_kit/routing/app_router.dart';
import 'package:pitel_ui_kit/styles/app_themes.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialPadArguments {
  DialPadArguments();
}

class DialPadWidget extends ConsumerStatefulWidget {
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
  final DialPadArguments arguments;
  DialPadWidget({Key? key, required this.arguments}) : super(key: key);

  @override
  ConsumerState<DialPadWidget> createState() => _MyDialPadWidget();
}

class _MyDialPadWidget extends ConsumerState<DialPadWidget>
    implements SipPitelHelperListener {
  late String _dest;
  PitelCall get pitelCall => widget._pitelCall;
  final TextEditingController _textController = TextEditingController();
  late SharedPreferences _preferences;

  String receivedMsg = '';
  PitelClient pitelClient = PitelClient.getInstance();
  String state = '';

  @override
  initState() {
    super.initState();
    state = pitelCall.getRegisterState();
    receivedMsg = '';
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
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Target is empty.'),
            content: const Text('Please enter a SIP URI or username!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      pitelClient.call(dest, voiceonly).then((value) => value.fold(
          (succ) => {},
          (err) =>
              {ref.read(receivedMsgProvider.notifier).state = err.toString()}));
      _preferences.setString('dest', dest);
    }
  }

  List<Widget> _buildDialPad() {
    return [
      SizedBox(
          width: 360,
          child: Text(
            ref.watch(receivedMsgProvider),
            textAlign: TextAlign.center,
          )),
      Container(
        color: Colors.amber,
        child: TextField(
          keyboardType: TextInputType.number,
          style: AppTextTheme.T20B,
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
      ActionButton(
        icon: Icons.dialer_sip,
        fillColor: Colors.green,
        onPressed: () => _handleCall(context, true),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildDialPad());
  }

  @override
  void registrationStateChanged(PitelRegistrationState state) {
    debugPrint('registrationStateChanged ${state.state.toString()}');
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        goBack();
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
      case PitelRegistrationStateEnum.REGISTERED:
        ref.read(registerStateProvider.notifier).state =
            PitelRegistrationStateEnum.REGISTERED;
        break;
    }
  }

  @override
  void onNewMessage(PitelSIPMessageRequest msg) {
    //Save the incoming message to DB
    var msgBody = msg.request.body as String;
    ref.read(receivedMsgProvider.notifier).state = msgBody;
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
