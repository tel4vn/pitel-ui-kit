# pitel_ui_kit

### Pitel UI Kit Demo

[![N|Solid](https://documents.tel4vn.com/img/pitel-logo.png)](https://documents.tel4vn.com/)

pitel_ui_kit is demo project.

## Installation

> **Note**
> Pitel UI Kit requires flutter version 3.13.7, dart version 3.1.3

- **Setup to wake up app**: please follow guide in [here](https://github.com/tel4vn/flutter-pitel-voip/blob/main/PUSH_NOTIF.md) to setting push notification (FCM for android), Pushkit (for IOS).
- In file `firebase_options.dart`, fill information from your google_service.json

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
    "authPass": "${Password}",
    "registerServer": "${Domain}",
    "outboundServer": "${Outbound Proxy}",
    "port": PORT,
    "accountName": "${UUser}",      // Example 101
    "displayName": "${UUser}@${Domain}",
    "wssUrl": "${URL WSS}",
    "apiDomain": "${URL API}"
});
```

- In file `app.dart` fill sip info data

```dart
  final PushNotifParams pushNotifParams = PushNotifParams(
    teamId: '${apple_team_id}',
    bundleId: '${bundle_id}',
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
