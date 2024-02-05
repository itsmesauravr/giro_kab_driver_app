import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/screens/submitted_screen.dart';
import 'package:giro_driver_app/features/auth/models/login_model.dart';
import 'package:giro_driver_app/features/auth/repo_services/auth_services.dart';
import 'package:giro_driver_app/features/auth/screens/signup_screen.dart';
import 'package:giro_driver_app/features/home/screens/home_screen.dart';
import 'package:giro_driver_app/features/trips/screens/new_arrival_booking.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';

class LoginProvider extends ChangeNotifier {
  final loginFormKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final _loginServices = AuthServices();

  bool remember = true;
  bool obscure = true;
  bool _isloading = false;

  bool get isloading => _isloading;

  void toggleRemeber() {
    remember = !remember;
    notifyListeners();
  }

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void loginUser(BuildContext context) async {
    try {
      if (_isloading) return;
      // if (!loginFormKey.currentState!.validate()) {
      //   return;
      // }
      FocusScope.of(context).requestFocus(FocusNode());

      final data = LoginData(
        driverId: mobileController.text,
        password: passwordController.text,
      );
      _isloading = true;
      notifyListeners();
      final status = await _loginServices.postLoginData(data, remember);
      _isloading = false;
      notifyListeners();
      if (status == '1') {
        Messenger.alert(color: kcSuccess, msg: AppStrings.onLoginSuccess);
        MyRouter.pushRemoveUntil(screen: const HomeScreen());
        return;
      } else if (status == '0') {
        Messenger.alert(color: kcSuccess, msg: AppStrings.onLoginSuccess);
        MyRouter.pushNamedAndRemoveUntil(MyRoutes.updatePersonalDetails);
        return;
      } else if (status == '2') {
        Messenger.alert(color: kcSuccess, msg: AppStrings.onLoginSuccess);
        MyRouter.pushRemoveUntil(screen: const ProfileSubmittedScreen());
        return;
      }
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  logout() async {
    _isloading = true;
    notifyListeners();
    final logout = await _loginServices.logOut();
    _isloading = false;
    notifyListeners();
    if (logout) {
      MyRouter.pushNamedAndRemoveUntil(MyRoutes.login);
    }
  }

  void isAlreadyLogin() async {
    final showOnBoarding = await _loginServices.showOnboarding();

    try {
      final logginStatus = await _loginServices.checkLogined();
      if (logginStatus['status'].toString() == '1') {
        final a = await AwesomeNotifications().getInitialNotificationAction();
        if (a != null) {
          log('>>>>>>>>........<<<<<<<<<');
          log(a.body.toString());
          if (a.payload?['type'] == 'new_booking') {
            MyRouter.push(screen: NewBookingArrivalScreen(data: a.payload!));
          return;
          }
        }

        MyRouter.pushRemoveUntil(screen: const HomeScreen());
        return;
      }
      if (logginStatus['profile_submission'].toString() == '0') {
        MyRouter.pushNamedAndRemoveUntil(MyRoutes.updatePersonalDetails);
        return;
      } else if (logginStatus['profile_submission'].toString() == '1') {
        MyRouter.pushRemoveUntil(screen: const ProfileSubmittedScreen());
        return;
      }
    } catch (_) {
    }

    if (showOnBoarding) {
      MyRouter.pushNamedAndRemoveUntil(MyRoutes.onBoarding);
      return;
    }
    MyRouter.pushNamedAndRemoveUntil(MyRoutes.login);
    return;
  }

  void gotoSignupScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ));
  }
}
