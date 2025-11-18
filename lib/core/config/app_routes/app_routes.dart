import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sbms_apps/core/presentations/screens/home/create_list_screen.dart';
import 'package:sbms_apps/core/presentations/screens/home/home_screen.dart';
import 'package:sbms_apps/core/presentations/screens/home/order_list_screen.dart';
import 'package:sbms_apps/core/presentations/screens/home/product_list_screen.dart';


import '../../presentations/screens/auth/signin/sign_in _screen.dart';
import '../../presentations/screens/home/bank_receivelist_screen.dart';
import '../../presentations/screens/home/sales_list_screen.dart';
import '../../presentations/screens/onboarding/onboarding_screen.dart';
import '../../presentations/screens/onboarding/onboarding_start_screen.dart';
import '../../presentations/screens/profile/view_profile_screen.dart';
import '../../presentations/screens/profile/view_update_profile_screen.dart';
import '../../presentations/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = "/splashScreen";
  static const String onBoardingScreen = "/onBoardingScreen";
  static const String onBoardingStartScreen = "/onBoardingStartScreen";

  /// =============================> Auth ================================>


  static const String logInScreen = "/logInScreen";
  static const String homeScreen = "/homeScreen";
  static const String productListScreen = "/productListScreen";
  static const String createScreen = "/createScreen";
  static const String orderListScreen = "/orderListScreen";
  static const String salesListScreen = "/salesListScreen";
  static const String viewProfileScreen = "/viewProfileScreen";
  static const String editProfileScreen = "/editProfileScreen";
  static const String bankReceiveListScreen = "/bankReceiveListScreen";






  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    routes: [
      GoRoute(
        path: splashScreen,
        name: splashScreen,
        builder: (context, state) => const SplashScreen(),
        redirect: (context, state) {
          Future.delayed(const Duration(seconds: 3), () async {
              AppRoutes.goRouter.replaceNamed(AppRoutes.onBoardingScreen);
            }
          );

          return;
        },
      ),

      ///<<<=============>>> ONBOARDING SCREEN <<<===============>>>
      GoRoute(
        path: onBoardingScreen,
        name: onBoardingScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(OnboardingScreen(), state),
      ),



      ///<<<=============>>> ONBOARDING Start SCREEN <<<===============>>>
      GoRoute(
        path: onBoardingStartScreen,
        name: onBoardingStartScreen,
        pageBuilder:
            (context, state) =>
            _customTransitionPage(OnboardingStartScreen(), state),
      ),

      /// =============================================================> Auth  =================================================>


      ///<<<=============>>> Log In <<<===============>>>
      GoRoute(
        path: logInScreen,
        name: logInScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(LoginInScreen(), state),
      ),


      ///<<<=============>>> Home Screen<<<===============>>>
      GoRoute(
        path: homeScreen,
        name: homeScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(HomeScreen(), state),
      ),

      ///<<<=============>>> Product List Screen<<<===============>>>
      GoRoute(
        path: productListScreen,
        name: productListScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(ProductListScreen(), state),
      ),


      GoRoute(
        path: createScreen,
        name: createScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(CreateScreen(), state),
      ),

      GoRoute(
        path: orderListScreen,
        name: orderListScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(OrderListScreen(), state),
      ),
      GoRoute(
        path: viewProfileScreen,
        name: viewProfileScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(ViewProfileScreen(), state),
      ),
      GoRoute(
        path: editProfileScreen,
        name: editProfileScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(EditProfileScreen(), state),
      ),
      GoRoute(
        path: salesListScreen,
        name: salesListScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(SalesListScreen(), state),
      ),
      GoRoute(
        path: bankReceiveListScreen,
        name: bankReceiveListScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(BankReceiveListScreen(), state),
      ),







    ],
  );

  static Page<dynamic> _customTransitionPage(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
