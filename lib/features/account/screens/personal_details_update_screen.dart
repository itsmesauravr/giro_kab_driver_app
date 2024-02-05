import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/models/profile_status_model.dart';
import 'package:giro_driver_app/features/account/repo_services/account_serivces.dart';
import 'package:giro_driver_app/features/account/screens/document_upload_screen.dart';
import 'package:giro_driver_app/features/account/screens/payment_screen.dart';
import 'package:giro_driver_app/features/account/screens/submitted_screen.dart';
import 'package:giro_driver_app/features/account/screens/vehicle_details_form_screen.dart';
import 'package:giro_driver_app/features/auth/screens/auth_screen.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';
import 'package:provider/provider.dart';

class PersonalDetailsUpdateScreen extends StatelessWidget {
  const PersonalDetailsUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProfileDetailsUpdateProvider>();
    return Stack(
      children: [
        Scaffold(
            backgroundColor: kcVeryLightGrey,
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
            body: FutureBuilder<ProfileStatus>(
                future: AccountServices.getProfileStatus(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // indicating that the async operation has begun
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    // When async operation is completed.
                    case ConnectionState.done:
                    default:
                      //if snapshot has data
                      if (snapshot.hasData) {
                        return ListView(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          children: [
                            MyListTile(
                              title: 'Profile Details',
                              icon: Icons.person_outline,
                              uploadStatus: snapshot.data?.profileUploadStatus,
                              approvalStatus:
                                  snapshot.data?.profileApprovalStatus,
                              onTap: () {
                                if(snapshot.data?.profileUploadStatus == '1'){
                                  Messenger.alert(msg: "Details already submitted");
                                  return;
                                }
                                
                                MyRouter.pushNamed(
                                    MyRoutes.personalDetailsForm);
                              },
                            ),
                            MyListTile(
                              title: 'Vehicle Details',
                              icon: Icons.car_rental_outlined,
                              uploadStatus: snapshot.data?.vehicleUploadStatus,
                              approvalStatus:
                                  snapshot.data?.vehicleApprovalStatus,
                              onTap: () {
                                if(snapshot.data?.vehicleUploadStatus == '1'){
                                  Messenger.alert(msg: "Details already submitted");
                                  return;
                                }
                                MyRouter.push(
                                    screen: const VehicleDetailFormsScreen());
                              },
                            ),
                            MyListTile(
                              title: 'Upload Front Side of License',
                              uploadStatus:
                                  snapshot.data?.licensefrontUploadStatus,
                              approvalStatus:
                                  snapshot.data?.licensefrontApprovalStatus,
                              icon: Icons.contact_mail_outlined,
                              onTap: () {
                                MyRouter.push(
                                  screen: DocumnetUploadScreen(
                                    doc: DocumnentInfo(
                                      rejctionKey:
                                          'licensefront_rejection_reason',
                                      uploadKey: 'license_frontfile',
                                      uploadStatus: snapshot
                                          .data?.licensefrontUploadStatus,
                                      description:
                                          'Take a photo of your driver\'s license (Front side).',
                                      documnetEndpoint:
                                          'driver-license-frontside',
                                      name: 'Driver\'s License Front Side',
                                      // type: DocumnentType.license,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MyListTile(
                              title: 'Upload Back Side of license',
                              uploadStatus:
                                  snapshot.data?.licensebackUploadStatus,
                              approvalStatus:
                                  snapshot.data?.licensebackApprovalStatus,
                              icon: Icons.contact_mail_outlined,
                              onTap: () {
                                MyRouter.push(
                                  screen: DocumnetUploadScreen(
                                    doc: DocumnentInfo(
                                      rejctionKey:
                                          'licensefront_rejection_reason',
                                      uploadStatus: snapshot
                                          .data?.licensebackUploadStatus,

                                      uploadKey: 'license_backfile',
                                       description:
                                          'Take a photo of your driver\'s license (Back side).',
                                      documnetEndpoint:
                                          'driver-license-backside',
                                      name: 'Driver\'s License Back Side',
                                      // type: DocumnentType.license,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MyListTile(
                              title: 'Upload Vehicle RC',
                              uploadStatus: snapshot.data?.rcUploadStatus,
                              approvalStatus: snapshot.data?.rcApprovalStatus,
                              icon: Icons.document_scanner_outlined,
                              onTap: () {
                                MyRouter.push(
                                  screen: DocumnetUploadScreen(
                                    doc: DocumnentInfo(
                                      rejctionKey: 'rc_rejection_reason',
                                      uploadStatus:
                                          snapshot.data?.rcUploadStatus,
                                      documentKey: 'rc_file',
                                      uploadKey: 'vehicle_rc',
                                      description: '',
                                      documnetEndpoint: 'vehicle-rc',
                                      name: 'Vehicle RC',
                                      // type: DocumnentType.rc,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MyListTile(
                              title: 'Vehicle Insurance',
                              uploadStatus:
                                  snapshot.data?.insuranceUploadStatus,
                              approvalStatus:
                                  snapshot.data?.insuranceApprovalStatus,
                              icon: Icons.document_scanner_outlined,
                              onTap: () {
                                MyRouter.push(
                                  screen: DocumnetUploadScreen(
                                    doc: DocumnentInfo(
                                      rejctionKey: 'insurance_rejection_reason',
                                      uploadStatus:
                                          snapshot.data?.insuranceUploadStatus,
                                      documentKey: 'insurance_file',
                                      uploadKey: 'vehicle_insurance',
                                      description: '',
                                      documnetEndpoint: 'vehicle-insurance',
                                      name: 'Vehicle Insurance',
                                      // type: DocumnentType.rc,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MyListTile(
                              title: 'Upload Pollution Certificate',
                              uploadStatus:
                                  snapshot.data?.pollutionUploadStatus,
                              approvalStatus:
                                  snapshot.data?.pollutionApprovalStatus,
                              icon: Icons.document_scanner_outlined,
                              onTap: () {
                                MyRouter.push(
                                  screen: DocumnetUploadScreen(
                                    doc: DocumnentInfo(
                                      rejctionKey: 'pollution_rejection_reason',
                                      uploadStatus:
                                          snapshot.data?.pollutionUploadStatus,
                                      documentKey: 'pollution_file',

                                      uploadKey: 'pollution_certificate',
                                      description: '',
                                      documnetEndpoint: 'pollution-certificate',
                                      name: 'Vehicle Polution Certificate',
                                      // type: DocumnentType.rc,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MyListTile(
                              title: 'Upload Vehicle Permit',
                              uploadStatus: snapshot.data?.permitUploadStatus,
                              approvalStatus:
                                  snapshot.data?.permitApprovalStatus,
                              icon: Icons.document_scanner_outlined,
                              onTap: () {
                                MyRouter.push(
                                  screen: DocumnetUploadScreen(
                                    doc: DocumnentInfo(
                                      rejctionKey: 'permit_rejection_reason',
                                      uploadStatus:
                                          snapshot.data?.permitUploadStatus,
                                      documentKey: 'permit_file',
                                      uploadKey: 'vehicle_permit',
                                      description: '',
                                      documnetEndpoint: 'vehicle-permit',
                                      name: 'Vehicle Permit',
                                      // type: DocumnentType.rc,
                                    ),
                                  ),
                                );
                              },
                            ),
                            MyListTile(
                              title: 'Payment',
                              paymentStatus: snapshot.data?.paymentStatus,
                              icon: Icons.payment,
                              onTap: () {
                                MyRouter.push(screen: const PaymentScreen());
                              },
                            ),
                            MyButton(
                              title: 'Submit',
                              onTap: provider.submitProfile, 
                            ),
                          ],
                        );
                      }
                      //if snapshot has error
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Something went wrong ${snapshot.error.toString()}'));
                      }
                      //if snapshot is null
                      return const Center(child: Text('No data found'));
                  }
                })),
      ],
    );
  }
}

class ProfileDetailsUpdateProvider extends ChangeNotifier {
  final services = AccountServices();
  Future<void> logoutDriver() async {
    try {
      await services.logoutDriver();
    } catch (e) {
      e;
    } finally {
      MyRouter.pushRemoveUntil(screen: const AuthScreen());
    }
  }

  Future<void> submitProfile() async {
    try {
      await services.finalSubmission();
      Messenger.alert(msg: 'Profile successfully submitted for approval.', color:kcSuccess );
      MyRouter.pushRemoveUntil(screen: const ProfileSubmittedScreen());
      return;
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          
          Messenger.alert(
              color: kcDanger,
              msg: e.response?.data['message'] ?? 'Something went wrong.'); 
        } else {
          Messenger.alert(color: kcDanger, msg: 'Something went wrong.');
        }
      }
      e;
    } finally {
    }
  }
}

class MyListTile extends StatelessWidget {
  const MyListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.approvalStatus,
    this.uploadStatus,
    this.paymentStatus,
  }) : super(key: key);

  final String title;
  final String? approvalStatus;
  final String? uploadStatus;
  final String? paymentStatus;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: kcPrimary,
            radius: 25,
            child: Icon(
              icon,
              color: kcLight,
              size: 29,
            ),
          ),
          title: BodyText(title),
          subtitle: getSubtitle(),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            if (approvalStatus == '1' || paymentStatus == '1') {
              return;
            }
            if (onTap != null) {
              onTap!();
            }
          },
        ),
      ),
    );
  }

  Text? getSubtitle() {
    if (paymentStatus == '1') {
      return const Text('Payment Completed');
    }
    if (uploadStatus == '0' && approvalStatus != '2') {
      return const Text('Upload Pending');
    }
    if (approvalStatus == '0') {
      return const Text('Approval Pending');
    } else if (approvalStatus == '1') {
      return const Text('Approved', style: TextStyle(color: kcSuccess));
    } else if (approvalStatus == '2') {
      return const Text('Rejected', style: TextStyle(color: kcDanger));
    }
    return null;
  }
}
