import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/auth/providers/login_provider.dart';
import 'package:giro_driver_app/utils/app_strings/asset_strings.dart';

import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Image.asset(Assets.logo),
        
      ),
    );
  }

  @override
  void initState() {
   final provider = context.read<LoginProvider>();
    Timer(
      const Duration(seconds: 2),
      () => provider.isAlreadyLogin(),
    );
    super.initState();
  }
}
