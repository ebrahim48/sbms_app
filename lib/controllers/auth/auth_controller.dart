// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/app_constants/app_constants.dart';
// import '../../core/config/app_routes/app_routes.dart';
// import '../../core/helpers/prefs_helper.dart';
// import '../../core/helpers/toast_message_helper.dart';
// import '../../core/services/api_client.dart';
// import '../../core/services/api_constants.dart';
//
// //
//
//
//
// class AuthController extends GetxController {
//
//
//
//
//
//
//
//
//
//
//
//
//   ///============================================= Log in ===============================================<>
//   RxBool logInLoading = false.obs;
//
//   handleLogIn(String email, String password, {required BuildContext context}) async {
//     logInLoading.value = true;
//
//     var headers = {'Content-Type': 'application/json'};
//     var body = {
//       "email": email,
//       "password": password,
//     };
//
//     var response = await ApiClient.postData(
//       ApiConstants.loginEndPoint,
//       jsonEncode(body),
//       headers: headers,
//     );
//
//     logInLoading.value = false;
//
//     print("========================${response.statusCode} \n ${response.body}");
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//
//
//       /// Access token save
//       var token = response.body["token"]['user'];
//       logger.d("token   .... ======>> $token");
//       await PrefsHelper.setString(AppConstants.bearerToken, token,);
//
//
//
//       /// Save user details
//       await PrefsHelper.setString(AppConstants.email, email);
//       await PrefsHelper.setString(AppConstants.userId, user['id']);
//
//
//
//       if (role == "user") {
//         await PrefsHelper.setBool(AppConstants.isLogged, true);
//         ToastMessageHelper.showToastMessage(
//             "You are logged in", title: 'Success');
//       }
//       context.pushNamed(AppRoutes.homeScreen);
//       else {
//         final message = response.body["message"];
//
//         else {
//           ToastMessageHelper.showToastMessage(
//             message,
//             title: 'attention',
//           );
//         }
//       }
//     }
//   }
//
//
//
//
//
//
// }