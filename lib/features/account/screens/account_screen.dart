import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/features/earnings/screens/daywise_earnings_screen.dart';
import 'package:giro_driver_app/features/home/models/user_model.dart';
import 'package:giro_driver_app/features/home/providers/home_provider.dart';
import 'package:giro_driver_app/features/home/screens/change_password.dart';
import 'package:giro_driver_app/features/home/screens/help_screen.dart';
import 'package:giro_driver_app/features/home/screens/terms_and_conditions.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/extensions/string_extensions.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          vSpace18,
          FutureBuilder<UserProfile?>(
              future: context.read<HomeProvider>().showProfileDetails(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // indicating that the async operation has begun
                  case ConnectionState.waiting:
                    return const Center(child: Text('Loading..'));
                  // When async operation is completed.
                  case ConnectionState.done:
                  default:
                    //if snapshot has data
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: kcLightGreyColor,
                              radius: 50,
                              child: CircleAvatar(
                                radius: 45,
                                foregroundImage: NetworkImage(
                                    '${AppStrings.siteUrl}/${data.photo}'),
                              ),
                            ),
                            Text(
                              data.name.toTitleCase(),
                              style: heading2Style,
                            ),
                            Text(
                              data.driverId,
                              style: bodyStyleBold,
                            )
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                }
              }),
          ListTile(
            onTap: () => MyRouter.push(screen: const EarningsScreen()),
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Earnigs",
              style: subheadingStyle,
            ),
          ),
          // ListTile(
          //   leading: Image.asset('assets/icons/drawerPlusIcons.png'),
          //   title: const Text(
          //     "Document Renewal",
          //     style: subheadingStyle,
          //   ),
          // ),
          ListTile(
            onTap: () =>
                MyRouter.push(screen: const TermsAndConditionsScreen()),
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Terms and Conditions",
              style: subheadingStyle,
            ),
          ),
          ListTile(
            onTap: () => MyRouter.push(screen: const HelpScreen()),
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Help",
              style: subheadingStyle,
            ),
          ),
          ExpansionTile(
            collapsedIconColor: kcLight,
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Settings",
              style: subheadingStyle,
            ),
            children: [
              ListTile(
                onTap: () =>
                    MyRouter.push(screen: const ChangePasswordScreen()),
                leading: hSpace25,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
                title: const Text(
                  "Change Password",
                  style: subheadingStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  showAlertDialog(
                      context,
                      context
                          .read<ProfileDetailsUpdateProvider>()
                          .logoutDriver);
                },
                leading: hSpace25,
                trailing: const Icon(
                  Icons.logout,
                  color: kcDanger,
                ),
                title: const Text(
                  "Logout",
                  style: subheadingStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(
    BuildContext context,
    VoidCallback logout,
  ) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Logout"),
      onPressed: () async {
        logout();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        MyRouter.pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
