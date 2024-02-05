import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/providers/otp_login_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/question_button.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({
    Key? key,
    required this.mobile,
  }) : super(key: key);
  final String mobile;
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentOTP = "";

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OtpLoginProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset('assets/img/otp.jpg'),
              ),
              RichText(
                text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                          text: widget.mobile,
                          style: bodyStyle),
                    ],
                    style: bodyStyle),
                textAlign: TextAlign.center,
              ),
              vSpace18,
              Form(
                key: formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: true,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,

                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 45,
                    fieldWidth: 45,
                    selectedColor: kcPrimary,
                    activeColor: kcLightGreyColor,
                    inactiveColor: kcLightGreyColor,
                    inactiveFillColor: kcVeryLightGrey,
                    activeFillColor: kcPrimary,
                  ), 

                  cursorColor: kcPrimary,
                  animationDuration: const Duration(milliseconds: 300),
                  errorAnimationController: errorController,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },

                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentOTP = value;
                    }); 
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                   return true;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ), 
              vSpace18,
              QuestionButton(
                onTap: () async {
                  provider.verifyMobileNumber(context); 
                  snackBar("OTP resent!!");
                },
                question: "Didn't receive the code? ",
                action: "Resend",
              ),
              vSpace10,
              MyButton(
                disabled: currentOTP.length!=6,   
                title: 'Verify',
                onTap: () {    
                  provider.verifyOtpNumber(context,currentOTP, widget.mobile); 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
