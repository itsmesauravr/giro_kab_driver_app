import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/features/auth/screens/splash_screen.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';

class ProfileSubmittedScreen extends StatelessWidget {
  const ProfileSubmittedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProfileDetailsUpdateProvider>();

    return  Scaffold(
      appBar: AppBar(
              backgroundColor: kcDark,
              title: Text(
                "Profile",
                style: bodyStyleBold.copyWith(color: Colors.white),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      await provider.logoutDriver();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: kcLight,
                    ))
              ],
            ),
      body: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/doc-verfication.jpg'),
                  vSpace18,
                const  Text(
            "Your profile has been submitted. We will update your status shortly",
            textAlign: TextAlign.center,
            style: TextStyle(
                    color: Color(0xff1f1f1f),
                    fontSize: 20,
                    fontFamily: "DM Sans",
                    fontWeight: FontWeight.w500,
            ),
            ),
            vSpace25,
            MyButton.outline(title: 'Refresh', onTap: () => MyRouter.pushRemoveUntil(screen:const SplashScreen()),)
                ],
              ),),
        ),
      )
    );
  }
}
