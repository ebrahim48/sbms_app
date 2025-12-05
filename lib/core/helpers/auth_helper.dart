import 'package:get/get.dart';
import '../app_constants/app_constants.dart';
import '../helpers/prefs_helper.dart';

class AuthHelper {
  static Future<bool> isLoggedIn() async {
    bool isLogged = await PrefsHelper.getBool(AppConstants.isLogged);
    String token = await PrefsHelper.getString(AppConstants.bearerToken);
    
    return isLogged && token.isNotEmpty;
  }
  
  static Future<void> logout() async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    await PrefsHelper.remove(AppConstants.email);
    await PrefsHelper.remove(AppConstants.name);
    await PrefsHelper.remove(AppConstants.userId);
    await PrefsHelper.setBool(AppConstants.isLogged, false);
  }
}