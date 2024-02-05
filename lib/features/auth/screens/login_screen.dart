import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/widgets/login_form.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/app_widgets/question_button.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: H1('Login to your \nAccount'),
            ),
            const SizedBox(
              height: 20,
            ),
            const LoginForm(),
            vSpace18, 
            // const Expanded(child: SizedBox()),
            Align(
                alignment: Alignment.bottomCenter,
                child: QuestionButton(
                  question: 'Not a Member? ',
                  action: 'Register.',
                  onTap: () {
                    MyRouter.pushReplacementNamed(MyRoutes.signup);
                  },
                )),
            vSpace25,
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
