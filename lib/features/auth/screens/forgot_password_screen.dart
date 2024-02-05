import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/app_strings/asset_strings.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const BodyText.bold('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Image.asset(Assets.forgotPassword),
              const BodyText(
                  'Select which contact details should we use to reset your password'),
              vSpace25,
              RestePassOptBtn(
                title: 'Via SMS',
                onTap: () {
                  // MyRouter.push(screen: const VerifyOtpScreen()); 
                },
                leading: const Icon(
                  Icons.chat_bubble_outline,
                  color: kcPrimary,
                ),
              ),
              vSpace10,
              RestePassOptBtn(
                title: 'Via Email',
                onTap: () {},
                leading: const Icon(
                  Icons.mail_outline,
                  color: kcPrimary,
                ),
              ),
            ],
          ),
        ));
  }
}

class RestePassOptBtn extends StatelessWidget {
  const RestePassOptBtn({
    this.leading,
    required this.onTap,
    required this.title,
    Key? key,
  }) : super(key: key);
  final String title;
  final void Function()? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 2,
            color: kcLightGreyColor,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: leading,
          ),
          title: BodyText(title),
        ),
      ),
    );
  }
}
