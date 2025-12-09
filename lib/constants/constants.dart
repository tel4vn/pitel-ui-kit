import 'package:flutter_pitel_voip/services/sip_info_data.dart';

const String APPLE_TEAM_ID = 'YOUR_APPLE_TEAM_ID_HERE';
const String BUNDLE_ID =
    "YOUR_APP_BUNDLE_ID_HERE"; // Example: com.yourcompany.yourapp

// SipInfoData Configuration
const String ACCOUNT_NAME = 'YOUR_ACCOUNT_NAME_HERE';
const String PASSWORD = 'YOUR_PASSWORD_HERE';
const String DOMAIN = 'YOUR_DOMAIN_HERE';
const String DISPLAY_NAME = 'YOUR_DISPLAY_NAME_HERE';
const String WSS_MOBILE = 'YOUR_WSS_MOBILE_HERE';
const int PORT = 50061;

SipInfoData sipInfoData = SipInfoData.fromJson({
  "accountName": ACCOUNT_NAME, // Example 101
  "authPass": PASSWORD,
  "registerServer": DOMAIN,
  "outboundServer": DOMAIN,
  "port": PORT, // Default 50061
  "displayName": DISPLAY_NAME, // John, Kate
  "wssUrl": WSS_MOBILE
});
