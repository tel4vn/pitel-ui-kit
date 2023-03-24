import 'package:pitel_ui_kit/services/local_storage/local_store.dart';

abstract class PreferencesRepository {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  saveAccount(Account account);
  Future<Account?> getAccountLocal();
  saveStateCall();
  Future<bool> getStateCall();
}
