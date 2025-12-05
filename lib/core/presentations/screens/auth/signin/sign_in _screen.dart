import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:sbms_apps/core/config/app_routes/app_routes.dart';

import '../../../../../controllers/auth_controller.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';


class LoginInScreen extends StatefulWidget {
  LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {



  AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _logKey = GlobalKey<FormState>();
  // Controllers
  final TextEditingController emailCtrl = TextEditingController();

  final TextEditingController passWordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            top: 18.h,
            right: 20.w,
            child: Container(
              width: 259.w,
              height: 195.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),


          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 158.w,
              height: 219.h,
              decoration: BoxDecoration(
                color: AppColors.textColor803D20.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),


          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _logKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),

                      // Title
                      CustomText(
                        text: AppString.loginYour,
                        fontsize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor3D3D3D,
                      ),

                      SizedBox(height: 8.h),

                      // Subtitle
                      CustomText(
                        textAlign: TextAlign.start,
                        text: AppString.loginYourSecurity,
                        fontsize: 14.sp,
                        color: AppColors.textColor5D5D5D,
                        maxline: 2,
                      ),

                      SizedBox(height: 32.h),

                      CustomTextField(
                        hintextColor: AppColors.textColor5D5D5D,
                        controller: emailCtrl,
                        hintText: AppString.email,
                        // prefixIcon: Assets.icons.email.svg(),
                        isEmail: true,
                      ),


                      SizedBox(height: 16.h),

                      CustomTextField(
                        hintextColor: AppColors.textColor5D5D5D,
                        controller: passWordCtrl,
                        // prefixIcon: Assets.icons.pass.svg(),
                        hintText: AppString.password,
                        isPassword: true,
                      ),








                      SizedBox(height: 32.h),

                      Obx(()=>
                          CustomButton(
                              loading: authController.logInLoading.value,
                              title: AppString.login,
                              onpress: (){
                                if (_logKey.currentState?.validate()?? true) {
                                  authController.handleLogIn(
                                      emailCtrl.text, passWordCtrl.text.trim(),
                                      context: context);
                                }
                              }
                          ),),



                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}