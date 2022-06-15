import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {

  static saveStringPrefs(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static saveBooleanPrefs(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static saveIntPrefs(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<String> getStringKeyPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedString = prefs.getString(key);

    if (savedString == null) {
      return "";
    }

    return savedString;
  }

  static Future<bool> getBoolKeyPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedBool = prefs.getBool(key);

    if (savedBool == null) {
      return false;
    }

    return savedBool;
  }

  static Future<int> getIntKeyPrefs(String key, {int defaultValue = 0}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedInt = prefs.getInt(key);

    if (savedInt == null) {
      return defaultValue;
    }

    return savedInt;
  }

}