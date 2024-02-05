import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BodyText.bold("Change Password")),
      body: SingleChildScrollView(
        padding:   const EdgeInsets.symmetric(horizontal: 18.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BodyText('Create Your New Password'),
            vSpace18,
            InputField(
              password: true,
              hintText: "New Password",
            ),
            InputField(
              password: true,
              hintText: "Confirm Password",
            ),
            vSpace18,
            Selector<LoginProvider, bool>(
              builder: (context, value, _) {
                final loginProvider = context.watch<LoginProvider>();

                return InkWell(
                  onTap: () {
                    loginProvider.toggleRemeber();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        loginProvider.remember
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: kcPrimary,
                      ),
                      hSpace10,
                      const BodyText('Remeber me'),
                    ],
                  ),
                );
              },
              selector: (p0, p1) => p1.remember,
            ),
            vSpace25,
            MyButton(
              title: 'Continue',
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
