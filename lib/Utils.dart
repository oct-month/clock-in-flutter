import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();
  static final String sharedKey = "school_code";

  static Future<bool> setSchoolCode(String schoolCode) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(sharedKey, schoolCode);
  }

  static Future<String> getSchoolCode() async {
    return _prefs.then((SharedPreferences prefs) {
      return (prefs.getString(sharedKey) ?? '');
    });
  }
}
