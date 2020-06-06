import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String IDENTIFICATION = "identification";
  static String TYPE_ID = "idtype";
  static SharedPreferences _prefs;

  static Future<void> load() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static int getIntValue(String key) {
    if (_prefs != null) {
      final counter = _prefs.getInt(key);
      return counter;
    } else {
      return 0;
    }
  }

  static String getStringValue(String key) {
    if (_prefs != null) {
      final String string = _prefs.getString(key);

      if(string!=null &&validateNumber(string)){
        return string;
      }else{
        return "";
      }

    } else {
      return "";
    }
  }
  static void setValue(String key,var value){
    if(_prefs!=null){
      _prefs.setString(key, value);
    }
  }

  static bool validateNumber(var str){
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }
}
