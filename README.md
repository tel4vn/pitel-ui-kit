# pitel_ui_kit

### Pitel UI Kit Demo

[![N|Solid](https://documents.tel4vn.com/img/pitel-logo.png)](https://documents.tel4vn.com/)

pitel_ui_kit is demo project.

## Installation

> **Note**
> Pitel UI Kit requires flutter version 3.38.1, dart version 3.10.0

- **Setup to wake up app**: please follow guide in [here](https://github.com/tel4vn/flutter-pitel-voip/blob/main/PUSH_NOTIF.md) to setting push notification (FCM for android), Pushkit (for IOS).

- In `lib/constants/constants.dart` fill your infomation from your `SIP ACCOUNT DOMAIN.pdf` to run example.
- In file `firebase_options.dart`, fill your infomation from your google_service.json

```dart
  // Replace information from your google_service.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '${apiKey}',
    appId: '${appId}',
    messagingSenderId: '${messagingSenderId}',
    projectId: '${projectId}',
    storageBucket: '${storageBucket}',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '${apiKey}',
    appId: '${appId}',
    messagingSenderId: '${messagingSenderId}',
    projectId: '${projectId}',
    storageBucket: '${storageBucket}',
    iosClientId: '${iosClientId}',
    iosBundleId: '${iosBundleId}',
  );
```

- In file `app.dart` fill sip info data

```dart
final sipInfoData = SipInfoData.fromJson({
    "accountName": "${Extension}",      // Example 101
    "authPass": "${Password}",
    "registerServer": "${Domain}",
    "outboundServer": "${Domain}",
    "port": PORT,                       // Default 50061
    "displayName": "${Display Name}",   // John, Kate
    "wssUrl": "${WSS Mobile}"
});
```

- In file `app.dart` fill sip info data

```dart
  final PushNotifParams pushNotifParams = PushNotifParams(
    teamId: '${APPLE_TEAM_ID}',
    bundleId: '${BUNDLE_ID}',
  );

  pitelService.setExtensionInfo(sipInfoData, pushNotifParams);
```

- Get device token from function (to test notification)

```dart
await PushVoipNotif.getDeviceToken();
```

- Get package

```yaml
flutter pub get
```

- Run source code

```yaml
flutter run
```
