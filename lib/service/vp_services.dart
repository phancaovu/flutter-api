import 'package:shared_preferences/shared_preferences.dart';

class AppServices {
  static getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('Token')!;
  }
}