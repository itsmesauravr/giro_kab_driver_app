import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        InputField(hintText: 'User Name',
        ),
        InputField(hintText: 'Password', labelText: 'password', password: true ,

        ),
         
      ],)),
    );
  }
}