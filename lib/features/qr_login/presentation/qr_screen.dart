import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitel_ui_kit/common_widgets/responsive_center.dart';
import 'package:pitel_ui_kit/constants/constants.dart';
import 'package:pitel_ui_kit/features/qr_login/presentation/qr_controller.dart';
import 'package:pitel_ui_kit/localization/string_hardcoded.dart';
import 'package:pitel_ui_kit/services/domain/sip_info_data.dart';
import 'package:pitel_ui_kit/services/http/http_service_provider.dart';
import 'package:pitel_ui_kit/services/storage/storage_service_provider.dart';
import 'package:pitel_ui_kit/utils/async_value_ui.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:xml/xml.dart';

class QRScreen extends ConsumerWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    final storageProvider = ref.read(storageServiceProvider);

    bool done = false;

    void popup() {
      done = true;
      context.pop();
    }

    void onQrViewCreated(QRViewController controller) {
      controller.scannedDataStream.listen((scanData) {
        if (!done) {
          done = true;
          final accountfXml = scanData.code ?? "";
          final document = XmlDocument.parse(accountfXml);
          final authPass = document.findAllElements('AuthPass').first;
          final registerServer =
              document.findAllElements('RegisterServer').first;
          final outboundServer =
              document.findAllElements('OutboundServer').first;
          final userID = document.findAllElements('UserID').first;
          final authID = document.findAllElements('AuthID').first;
          final accountName = document.findAllElements('AccountName').first;
          final displayName = document.findAllElements('DisplayName').first;
          final dialPlan = document.findAllElements('Dialplan').first;
          final randomPort = document.findAllElements('RandomPort').first;
          final voicemail = document.findAllElements('Voicemail').first;

          final userName = document.findAllElements('UserName').first;
          final wssUrl = document.findAllElements('WssUrl').first;
          final apiDomain = document.findAllElements('APIDomain').first;

          final sipInfoData = SipInfoData(
              authPass: authPass.text,
              registerServer: registerServer.text,
              outboundServer: outboundServer.text,
              userID: int.parse(userID.text),
              authID: int.parse(authID.text),
              accountName: accountName.text,
              displayName: displayName.text,
              wssUrl: wssUrl.text,
              userName: userName.text,
              apiDomain: apiDomain.text);
          storageProvider.set(SIP_INFO_KEY, sipInfoData.toJson()).then((value) {
            //update new token of api
            ref.refresh(httpServiceProvider);
          });

          //! DOCS Here
          ref
              .read(qrScreenControllerProvider.notifier)
              .summitQRData(sipInfoData);
          popup();
        }
      });
    }

    ref.listen<AsyncValue>(
      qrScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(qrScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: state.isLoading
            ? const CircularProgressIndicator()
            : Text('QR Scan'.hardcoded),
      ),
      body: ResponsiveCenter(
        child: QRView(
            key: qrKey,
            onQRViewCreated: onQrViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 5,
              cutOutSize: 250,
            )),
      ),
    );
  }
}
