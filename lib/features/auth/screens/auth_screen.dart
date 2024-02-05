import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/img/login-img.png'),
              vSpace50,
              const H1('Login to your \nAccount'),
              vSpace18,
              MyButton(
                title: 'Continue with Mobile Number',
                onTap: () => MyRouter.pushNamed(MyRoutes.loginWithMobile),
              ),
              MyButton.outline(
                title: 'Login',
                onTap: () => MyRouter.pushNamed(MyRoutes.login),
              ),
              vSpace25,
            ],
          ),
        ),
      ),
    );
  }
}
