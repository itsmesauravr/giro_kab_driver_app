import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/alow_expanded.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/form_validators/form_validators.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';

class ChnagePasswordProvider extends ChangeNotifier {
  bool isBusy = false;

  Future<void> changePassword(String password) async {
    try {
      isBusy = true;
      notifyListeners();

      final dio = await InterceptorHelper.getApiClient();
      final res = await dio
          .post('driver-password-change', data: {'new_password': password});

      if (res.statusCode == 200) {
        Messenger.alert(msg: 'Password changed successfully', color: kcSuccess);
        MyRouter.pop();
        return;
      }

    } catch (_) {
        Messenger.alert(msg: 'Password changed successfully', color: kcSuccess);
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
     final passController = TextEditingController();
     final confPassController = TextEditingController();
    

    return ChangeNotifierProvider(
      lazy: true,
      create: (context) => ChnagePasswordProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: AllowExpanded(
              colomn: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    validator: FormValidator.validatePassword,
                    password: true,
                    labelText: 'Password',
                    hintText: 'Enter a password',
                    controller: passController,
                  ),
                  InputField(
                    validator: (p0) => FormValidator.validateConfirmPassword(p0, passController.text),
                    password: true,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    controller: confPassController,
                  ),
                  const Expanded(child: vSpace25),
                  Selector<ChnagePasswordProvider,bool>(
                    selector: (p0, p1) => p1.isBusy,
                    builder: (context,v,_) {
                      
                      return MyButton(
                        busy: v,
                        title: 'Change Password',
                        onTap:(){
                          if(formKey.currentState!.validate()){
                            context.read<ChnagePasswordProvider>().changePassword(passController.text);
                          }
                        },
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
