import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/providers/login_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/form_validators/form_validators.dart';

import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginProvider>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: loginProvider.loginFormKey,
        child: Column(
          children: [
            InputField(
                leading:const  Icon(Icons.person_outline),
              validator: FormValidator.validate,
              hintText: 'Driver ID',
              inputType: TextInputType.text, 
              inputAction: TextInputAction.next,
              controller: loginProvider.mobileController,
            ),
            Selector<LoginProvider, bool>(
              builder: (context, value, child) => InputField(
                leading:const  Icon(Icons.lock_outline) , 
                validator: FormValidator.validatePassword,
                hintText: 'Password',
                password: value,
                trailing: Icon(!value ? Icons.visibility : Icons.visibility_off),
                trailingTapped: loginProvider.toggleObscure,
                inputAction: TextInputAction.done,
                controller: loginProvider.passwordController,
              ),
              selector: (context, provider) => provider.obscure,
            ),
            // vSpace18,  

          //  Selector<LoginProvider, bool>(
          //       builder: (context,value,_) {
          //         return InkWell(
          //           onTap: () {
          //             loginProvider.toggleRemeber(); 
          //           },
          //           child: Row(
          //            mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center, 
          //             children: [
          //               Icon(loginProvider.remember? Icons.check_box:  Icons.check_box_outline_blank,color: kcPrimary,) , 
          //               hSpace10, 
          //               const BodyText('Remeber me'),
          //             ],
          //           ),
          //         );
          //       },
          //       selector: (p0, p1) => p1.remember,
          //     ),
            
            vSpace18, 
            Selector<LoginProvider, bool>(
              builder: (context, value, child) {
                return MyButton(
                  busy: loginProvider.isloading,
                  title: 'Login',
                  onTap: () {
                    loginProvider.loginUser(context);
                  },
                );
              },
              selector: (p0, p1) => p1.isloading,
            ),
            
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: TextButton(onPressed: () {
            //     MyRouter.pushNamed(MyRoutes.forgotPassword);  
            //   }, child:const Text('Forgot password?')), 
            // ),
            
          ],
        ),
      ),
    );
  }
}
