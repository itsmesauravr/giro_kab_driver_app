import 'dart:developer';

import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:giro_driver_app/features/auth/models/franchise_model.dart';
import 'package:giro_driver_app/features/auth/models/login_model.dart';
import 'package:giro_driver_app/features/auth/models/signup_model.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/notification/notification_helper.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';

class AuthServices {
  //to singleton
  static final AuthServices _singleton = AuthServices._internal();
  factory AuthServices() {
    return _singleton;
  }
  AuthServices._internal();

  Future<String> postLoginData(LoginData credentials, bool remember) async {
    final a = await SecuredStorage.instance.read('driverId');
    log(a.toString());
    try {
      // final token = await FirebaseMessaging.instance.getToken();
      final token =await LocalNotification.getFirebaseMessagingToken();

      final dio = await InterceptorHelper.getApiClient();
      final data = credentials.toJson();
      data.addAll({'device_key': token.toString()});
      final response = await dio.post('driver-password-login', data: data);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await SecuredStorage.instance.write('accessToken', token);

        if (remember) {
          await SecuredStorage.instance.write('driverId', credentials.driverId);
          await SecuredStorage.instance.write('password', credentials.password);
        }
        Messenger.alert(msg: AppStrings.onLoginSuccess, color: kcSuccess);
        return response.data['status'].toString();
      }

      return '-1';
    } catch (e) {
      if (e is DioError) {
        Messenger.alert(
            msg: e.response?.data['message'] ?? AppStrings.onError,
            color: kcDanger);
      }
      log(e.toString());

      return '-1';
    }
  }

  Future<bool> verifyMobile(String mobile) async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res =
          await dio.post('driver-mobile-verify', data: {"mobile": mobile});
      if (res.statusCode == 200) return true;
      throw 'Something went wrong';
    } catch (e) {
      if (e is DioError) {
        log(e.response.toString());
      }
      rethrow;
    } finally {}
  }

  Future<String> verifyOtp(String mobile, String otp) async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      // final token = await NotificationController.requestFirebaseToken();
      // final token = await FirebaseMessaging.instance.getToken();
      final token = await LocalNotification.getFirebaseMessagingToken();
      final res = await dio.post('driver-otp-login',
          data: {"mobile": mobile, "otp": otp, 'device_key': token});
      if (res.statusCode == 200) {
        final token = res.data['token'];
        await SecuredStorage.instance.write('accessToken', token);

        if (res.data['status'].toString() == '0') {
          final submisson = res.data['profile_submission_status'].toString();
          if (submisson == '0') {
            return '0';
          } else {
            return '2';
          }
        }
        return res.data['status'].toString();
      }

      throw 'Something went wrong';
    } catch (e) {
      if(e is DioError){
        log(e.response.toString());
        log(e.response?.statusCode.toString()??'');
        log(e.requestOptions.data);
  
      }
      
      log(e.toString());
      rethrow;
    } finally {}
  }

  Future<void> postSignupData(SignUpData details) async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      log('started signup');
      final response =
          await dio.post('driver-registration', data: details.toJson());
      log('signup completed');
      if (response.statusCode == 200) {
        log(response.data.toString());
        Messenger.alert(msg: AppStrings.onRegisterSuccess, color: kcSuccess);
        return;
      }
      throw '';
    } catch (e) {
      if (e is DioError) {
        Messenger.alert(
            msg: e.response?.data['message'] ?? AppStrings.onError,
            color: kcDanger);
      }
      log(e.toString());

      rethrow;
    }
  }

  Future<dynamic> checkLogined() async {
    try {
      final token = await SecuredStorage().read('accessToken');
      if (token != null) {
        final status = await getProfileStatus();
        return status;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> showOnboarding() async {
    final show = await SecuredStorage().read('showOnBoarding');
    if (show != null && show == 'false') return false;
    return true;
  }

  Future<dynamic> getProfileStatus() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-profile-status');
      if (res.statusCode == 200) {


        return res.data;
      }
      return null;
    } catch (e) {
      e;
    } finally {
      log('completed');
    }
  }

  logOut() async {
    await SecuredStorage.instance.delete('accessToken');
    return true;
  }

  Future<List<Franchise>> getAllFrachise() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('all-franchise');
      if (res.statusCode == 200) {
        return List<Franchise>.from(
            res.data["franchise"].map((x) => Franchise.fromJson(x)));
      }
      throw '';
    } catch (e) {
      rethrow;
    }
  }
}
