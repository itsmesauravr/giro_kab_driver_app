import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/providers/signup_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/app_widgets/question_button.dart';
import 'package:giro_driver_app/utils/form_validators/form_validators.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';

import 'package:provider/provider.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.read<SignUpProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: signupProvider.signUpFormKey,
        child: Column(
          children: [
            InputField(
              validator: FormValidator.validateName,
              hintText: 'Name',
              inputType: TextInputType.name,
              inputAction: TextInputAction.next,
              controller: signupProvider.nameController,
            ),
            InputField(
              validator: FormValidator.validateMobile,
              hintText: 'Mobile Number',
              inputType: TextInputType.phone,
              inputAction: TextInputAction.next,
              controller: signupProvider.emailController,
            ),
            FutureBuilder(
              future: signupProvider.getFranchise(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dropdownList = snapshot.data
                      ?.map((e) => DropdownMenuItem(
                          value: e.id, child: Text(e.franchiseName)))
                      .toList();
                  return InputField.dropdown(
                    dropDownValidator: (value) {
                      if (value == null) return "Please select a franchise";
                      return null;
                    },
                    controller: signupProvider.franchiseController,
                    onChanged: (value) {
                      signupProvider.franchiseController.text = value.toString(); 
                    },
                    items: dropdownList ?? <DropdownMenuItem<int>>[],
                    hintText: 'Sub Division',
                  );
                }
                if(snapshot.hasError){
                  return InputField.dropdown(
                  dropDownValidator: (value) {
                    if (value == null) return "Please select a franchise";
                    return null;
                  },
                  controller: signupProvider.franchiseController,
                  onChanged: ((p0) {}),
                  items: const [
                    DropdownMenuItem(
                        value: 0, child: Text('Error on Loading Franchise...')),
                  ],
                  hintText: 'Franchise',
                );
                }
                return InputField.dropdown(
                  dropDownValidator: (value) {
                    if (value == null) return "Please select a franchise";
                    return null;
                  },
                  controller: signupProvider.franchiseController,
                  onChanged: ((p0) {}),
                  items: const [
                    DropdownMenuItem(
                        value: 0, child: Text('Loading Franchise...')),
                  ],
                  hintText: 'Franchise',
                );
              },
            ),
            Selector<SignUpProvider, bool>(
              builder: (context, value, child) => InputField(
                validator: FormValidator.validatePassword,
                hintText: 'Password',
                password: value,
                trailing:
                    Icon(!value ? Icons.visibility : Icons.visibility_off),
                trailingTapped: signupProvider.toggleObscure,
                inputAction: TextInputAction.done,
                controller: signupProvider.passwordController,
              ),
              selector: (context, provider) => provider.obscure,
            ),
            Selector<SignUpProvider, bool>(
              builder: (context, value, child) => InputField(
                validator: (value) => FormValidator.validateConfirmPassword(
                    value, signupProvider.passwordController.text),
                hintText: 'Confirm Password',
                password: value,
                trailing:
                    Icon(!value ? Icons.visibility : Icons.visibility_off),
                trailingTapped: signupProvider.toggleReObscure,
                inputAction: TextInputAction.done,
                controller: signupProvider.rePasswordController,
              ),
              selector: (context, provider) => provider.reObscure,
            ),
            Selector<SignUpProvider, bool>(
              builder: (context, value, child) {
                return MyButton(
                  busy: signupProvider.isloading,
                  title: 'Register',
                  onTap: () {
                    signupProvider.signupDriver(context);
                  },
                );
              },
              selector: (p0, p1) => p1.isloading,
            ),
            QuestionButton(
              question: 'Do you already have an account?  ',
              action: 'Login',
              onTap: () {
                MyRouter.pushReplacementNamed(MyRoutes.login);
              },
            )
          ],
        ),
      ),
    );
  }
}
