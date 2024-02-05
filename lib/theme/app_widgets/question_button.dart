import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';

class QuestionButton extends StatelessWidget {
  final String question;
  final String action;
  final void Function()? onTap;
  const QuestionButton({
    required this.question,
    required this.action,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            BodyText(question),
            BodyText.bPrimary(action), 
          ],
        ),
      ),
    );
  }
}