import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';


import '../../presentations/screens/auth/signin/sign_in _screen.dart';
import '../../presentations/screens/onboarding/onboarding_screen.dart';
import '../../presentations/screens/onboarding/onboarding_start_screen.dart';
import '../../presentations/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = "/splashScreen";
  static const String onBoardingScreen = "/onBoardingScreen";
  static const String onBoardingStartScreen = "/onBoardingStartScreen";

  /// =============================> Auth ================================>


  static const String logInScreen = "/logInScreen";






  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    routes: [
      // GoRoute(
      //   path: splashScreen,
      //   name: splashScreen,
      //   builder: (context, state) => const SplashScreen(),
      //   redirect: (context, state) {
      //     Future.delayed(const Duration(seconds: 3), () async {
      //         AppRoutes.goRouter.replaceNamed(AppRoutes.onBoardingScreen);
      //       }
      //     );
      //
      //     return;
      //   },
      // ),

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
