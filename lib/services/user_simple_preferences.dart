import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keyPincode = 'pincodeText';
  static const _keyDate = 'dateText';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setPincode(String pinCodeText) async =>
      await _preferences!.setString(_keyPincode, pinCodeText);

  static String? getPincode() => _preferences!.getString(_keyPincode);

  static Future setDate(String dateText) async =>
      await _preferences!.setString(_keyDate, dateText);

  static String? getDate() => _preferences!.getString(_keyDate);
}
