import 'package:pitel_ui_kit/services/local_storage/references_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage implements PreferencesRepository {
  static const String _USER_NAME = 'username';
  static const String _PASSWORD = 'username';
  static const String _STATE_CALL = 'state-call';
  static const String SIP_INFO_KEY = "Sip_INFO_DATA";
  static const String APP_NAME = "PITEL";

  static final LocalStorage _localStorage = LocalStorage._internal();

  factory LocalStorage() => _localStorage;

  LocalStorage._internal();

  _getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<bool?> getBool(String key) async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    return sharedPreferences.getBool(key + APP_NAME);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    return await sharedPreferences.setBool(key + APP_NAME, true);
  }

  @override
  Future<bool> setString(String key, String value) async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    return await sharedPreferences.setString(key + APP_NAME, value);
  }

  @override
  Future<String?> getString(String key) async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    return sharedPreferences.getString(key + APP_NAME);
  }

  @override
  Future<Account?> getAccountLocal() async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    String? username = sharedPreferences.getString(_USER_NAME);
    String? password = sharedPreferences.getString(_PASSWORD);
    if (username != null && password != null) {
      return Account(username, password);
    }
    return null;
  }

  @override
  Future<bool> getStateCall() async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    bool stateCall = sharedPreferences.getBool(_STATE_CALL) ?? false;
    return stateCall;
  }

  @override
  saveAccount(account) async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    await sharedPreferences.setString(_USER_NAME, account.username);
    await sharedPreferences.setString(_PASSWORD, account.password);
  }

  @override
  saveStateCall() async {
    SharedPreferences sharedPreferences = await _getSharedPreference();
    await sharedPreferences.setBool(_STATE_CALL, true);
  }
}

final localStoreProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

class Account {
  final String username;
  final String password;

  Account(this.username, this.password);
}
