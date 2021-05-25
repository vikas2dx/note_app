import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static PreferencesUtils _preferences = PreferencesUtils._internal();

  factory PreferencesUtils() {
    return _preferences;
  }

  PreferencesUtils._internal();

  void saveString(String key, String value) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(key, value);
  }

  void saveDouble(String key, double value) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setDouble(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(key) ?? '';
  }

  Future<double> getDouble(String key) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getDouble(key) ?? 0.0;
  }

  saveInt(String key, int value) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getInt(key) ?? 0;
  }

  saveBool(String key, bool value) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getBool(key) ?? false;
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getStringList(key) ?? [];
  }

  setStringList(String key, List<String> list) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setStringList(key, list);
  }

  removeAll(String key) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.remove(key);
  }

  saveLoginDaa(UserCredential userCredential) {
    saveBool(PreferencesKeys.IS_LOGIN, true);
    saveString(PreferencesKeys.EMAIL_ID, userCredential.user.email);
    saveString(PreferencesKeys.UID, userCredential.user.uid);
  }
}

abstract class PreferencesKeys {
  static const IS_LOGIN = "is_Login";
  static const EMAIL_ID = "email_id";
  static const UID = "uid";
}
