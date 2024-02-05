import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/widgets/signup_form.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
        toolbarHeight: 55, 
      ), 
      resizeToAvoidBottomInset: true,
      body: SafeArea( 
        child: SingleChildScrollView(
            child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      H1('Registration'),
                      BodyText('Please register to start this journey.'),
                    ],
                  ),
                )),
            const SignupForm(),
          ],
        )),
      ),
    );
  }
}


