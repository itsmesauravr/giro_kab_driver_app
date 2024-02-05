import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/screens/submitted_screen.dart';
import 'package:giro_driver_app/features/auth/repo_services/auth_services.dart';
import 'package:giro_driver_app/features/auth/screens/verify_otp_screen.dart';
import 'package:giro_driver_app/features/home/screens/home_screen.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';

class OtpLoginProvider extends ChangeNotifier {
  final mobileNumberFormKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();

  bool _isloading = false;
  bool get isloading => _isloading;

  final _loginServices = AuthServices();

  void verifyMobileNumber(BuildContext context) async {
    if (_isloading) return;
    if (!mobileNumberFormKey.currentState!.validate()) {
      return;
    }
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      _isloading = true;
      notifyListeners();
      final valid = await _loginServices.verifyMobile(mobileController.text);
      if (valid) {
        MyRouter.push(screen:  VerifyOtpScreen(mobile: mobileController.text,));
        Messenger.alert(color: kcSuccess, msg: 'Otp sent successfully');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          Messenger.alert(
              color: kcDanger,
              msg: e.response?.data['message'] ?? 'Something went wrong.');
        } else {
          Messenger.alert(color: kcDanger, msg: 'Something went wrong.');
        }
      }

      log(e.toString());
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  void verifyOtpNumber(BuildContext context, String otp, String mobile) async {
    if (_isloading) return;
    _isloading =true;
    notifyListeners();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      _isloading = true;
      notifyListeners();
      final status = await _loginServices.verifyOtp(mobile.trim(), otp);
      if (status == '1') {
        Messenger.alert(color: kcSuccess, msg: AppStrings.onLoginSuccess);
        MyRouter.pushRemoveUntil(screen:const HomeScreen());
        return;

      } else if (status == '0') {
        Messenger.alert(color: kcSuccess, msg: AppStrings.onLoginSuccess);
        MyRouter.pushNamedAndRemoveUntil(MyRoutes.updatePersonalDetails);
        return;

      } else if (status =='2') {
        Messenger.alert(color: kcSuccess, msg: AppStrings.onLoginSuccess);
        MyRouter.pushRemoveUntil(screen:const ProfileSubmittedScreen());
        return;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          
          Messenger.alert(
              color: kcDanger,
              msg: e.response?.data['message'] ?? 'Something went wrong.'); 
        } else {
          Messenger.alert(color: kcDanger, msg: 'Something went wrong.');
        }
      }

      log(e.toString());
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
