import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/providers/otp_login_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/app_widgets/question_button.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/form_validators/form_validators.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';
import 'package:provider/provider.dart';

class LoginWithMobileScreen extends StatelessWidget {
  const LoginWithMobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OtpLoginProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 56,
      ),
      body: Form(
        key: provider.mobileNumberFormKey, 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/img/mobile number.png'),
                  Column(
                    children: [
                      vSpace10,
                      const H1('Enter your Mobile Number'),
                      vSpace25,
                      InputField(
                        inputType: TextInputType.phone,
                        validator: FormValidator.validateMobile, 
                        hintText: "Mobile Number",
                        controller:  provider.mobileController,
                      ), 
                    ],
                  ),
                  vSpace25,
                  Selector<OtpLoginProvider,bool>(
                    selector: (p0, p1) => p1.isloading,
                    builder: (context, value, child) => 
                   MyButton(
                      busy: provider.isloading, 
                      title: "Sign In", onTap: () {
                    
                        
                      provider.verifyMobileNumber(context);
                    }),
                  ),
                  vSpace25,
                  Align(
                alignment: Alignment.bottomCenter,
                child: QuestionButton(
                  question: 'Not a Member? ',
                  action: 'Register.',
                  onTap: () {
                    MyRouter.pushReplacementNamed(MyRoutes.signup); 
                  },
                )),
                ]),
          ),
        ),
      ),
    );
  }
}
