import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../core/app_constants/app_constants.dart';
import '../core/config/app_routes/app_routes.dart';
import '../core/helpers/prefs_helper.dart';
import '../core/helpers/toast_message_helper.dart';
import '../core/services/api_client.dart';
import '../core/services/api_constants.dart';

class AuthController extends GetxController {
  ///============================================= Log in ===============================================<>
  RxBool logInLoading = false.obs;

  Future<bool> handleLogIn(String email, String password, {required BuildContext context}) async {
    logInLoading.value = true;

    var body = {
      "email": email,
      "password": password,
    };

    try {
      var response = await ApiClient.postData(
        ApiConstants.loginEndPoint,
        body, // No need for jsonEncode here as ApiClient handles it
      );

      logInLoading.value = false;

      print("========================${response.statusCode} \n ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract token correctly from the response structure
        String token = response.body["res"]["token"];

        // Extract user details
        var userData = response.body["res"]["user"];
        int userId = userData["id"];
        String userName = userData["name"];

        // Save token to preferences
        await PrefsHelper.setString(AppConstants.bearerToken, "Bearer $token");

        // Save user details
        await PrefsHelper.setString(AppConstants.email, email);
        await PrefsHelper.setString(AppConstants.name, userName);
        await PrefsHelper.setInt(AppConstants.userId, userId);
        await PrefsHelper.setBool(AppConstants.isLogged, true);

        // Show success message
        ToastMessageHelper.showToastMessage("You are logged in", title: 'Success');

        // Navigate to home screen
        context.pushNamed(AppRoutes.homeScreen);

        return true;
      } else {
        // Handle error response
        String message = response.body["msg"] ?? "Login failed";
        ToastMessageHelper.showToastMessage(message, title: 'Error');
        return false;
      }
    } catch (e) {
      logInLoading.value = false;
      print("Login error: $e");
      ToastMessageHelper.showToastMessage("Invalid email or Password", title: 'Error');
      return false;
    }
  }
}