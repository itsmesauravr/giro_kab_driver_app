import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/models/franchise_model.dart';
import 'package:giro_driver_app/features/auth/models/signup_model.dart';
import 'package:giro_driver_app/features/auth/repo_services/auth_services.dart';
import 'package:giro_driver_app/features/auth/screens/verify_otp_screen.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';

class SignUpProvider extends ChangeNotifier {
  final signUpFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final franchiseController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  final _signUpServices = AuthServices();

  bool _isloading = false;
  bool obscure = true;
  bool reObscure = true;

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void toggleReObscure() {
    reObscure = !reObscure;
    notifyListeners();
  }

  bool get isloading => _isloading;

  void signupDriver(BuildContext context) async {
    try {
      if (franchiseController.text== '0'||franchiseController.text== '')  {
        Messenger.alert(msg: 'Please select a franchise');
        return;
      }
      if (_isloading) return;
      if (!signUpFormKey.currentState!.validate()) {
        return;
      }
       if (franchiseController.text== '0'||franchiseController.text== '')  {
        return;
      }
      FocusScope.of(context).requestFocus(FocusNode());

      final data = SignUpData(
        franchise: franchiseController.text,
        mobile: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );
      _isloading = true;
      notifyListeners();
      await _signUpServices.postSignupData(data);
      MyRouter.push(screen: VerifyOtpScreen(mobile: data.mobile));
    } catch (e) {
      return;
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  Future<List<Franchise>> getFranchise() async {
    try {
      final data = await _signUpServices.getAllFrachise();
      if (data.isEmpty) throw 'Fraichise is not awailbe for this location';
     
      return data;
    } catch (e) {
      rethrow;
    }
  }

  void gotoLoginScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
