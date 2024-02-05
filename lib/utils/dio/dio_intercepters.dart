import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:giro_driver_app/features/auth/screens/splash_screen.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';

class InterceptorHelper {
  static final storage = SecuredStorage.instance;
  static Dio dio = Dio(BaseOptions(
    baseUrl: AppStrings.apiBaseUrl,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
  ));
  static Future<Dio> getApiClient() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (req, handler) async {
          final token = await storage.read('accessToken');
          log('token is $token');
          print(token);
          dio.interceptors.clear();
          req.headers.addAll(
              {"Authorization": "Bearer $token", 'Accept': 'application/json'});
          return handler.next(req);
        },
        onError: (e, handler) async {
          log(e.requestOptions.uri.toString());

          if (e.response?.statusCode == 4030000 ||
              e.response?.statusCode == 401) {
            await storage.delete('accessToken');

            MyRouter.pushRemoveUntil(screen: const SplashScreen());
          }
          return handler.next(e);
        },
      ),
    );
    return dio;
  }
}

Future<bool> internetCheck() async {
  try {
    final List<InternetAddress> result =
        await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 60));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  } catch (_) {
    return false;
  }
}
