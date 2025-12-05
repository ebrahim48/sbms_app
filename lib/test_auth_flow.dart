import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';
import '../core/config/app_routes/app_routes.dart';
import '../core/helpers/auth_helper.dart';
import '../core/helpers/prefs_helper.dart';
import '../core/services/api_client.dart';

// This is a test file to verify all imports work correctly
class TestAuthFlow extends StatelessWidget {
  const TestAuthFlow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  // Test function to verify auth flow works
  static Future<void> testAuthFlow() async {
    // Test getting auth controller
    final authController = Get.find<AuthController>();
    
    // Test auth helper
    bool isLoggedIn = await AuthHelper.isLoggedIn();
    print('User is logged in: $isLoggedIn');
    
    // Test preferences
    String token = await PrefsHelper.getString('bearerToken');
    print('Current token: $token');
    
    // Test route navigation
    print('Available routes:');
    print('Home: ${AppRoutes.homeScreen}');
    print('Login: ${AppRoutes.logInScreen}');
  }
}