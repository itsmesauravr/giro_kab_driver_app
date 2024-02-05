import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/models/district_model.dart';
import 'package:giro_driver_app/features/account/models/profile_form_model.dart';
import 'package:giro_driver_app/features/account/models/state_model.dart';
import 'package:giro_driver_app/features/account/repo_services/account_serivces.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/app_widgets/cached_circle_avatar.dart';
import 'package:giro_driver_app/theme/app_widgets/single_shimmer.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/form_validators/form_validators.dart';
import 'package:giro_driver_app/utils/img_picker/img_picker.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';

class PersonalDetailsFormScreen extends StatelessWidget {
  const PersonalDetailsFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProfileFormProvider>();
    final dropdownList = provider.booldGroups
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const BodyText.bold("Personal Details"),
          ),
          body: Form(
              key: provider.personalFormKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    FutureBuilder<String>(
                        future: provider.showProfilePic(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            // indicating that the async operation has begun
                            case ConnectionState.waiting:
                              return const ClipOval(
                                  child: SingleShimmer(
                                width: 180,
                                height: 180,
                              ));
                            default:
                              log(snapshot.data.toString());
                              return Selector<ProfileFormProvider, bool>(
                                selector: (_, provider) => provider.isBusy,
                                builder: (_, isLoading, __) {
                                  return Stack(
                                    children: [
                                      CachedAvatar(
                                        imageUrl:
                                            "${AppStrings.siteUrl}/${provider.profilePic}",
                                        height: 180,
                                        width: 180,
                                        onTap: () async {
                                          showAlertDialog(
                                              context, provider.postProfilePic);
                                        },
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          backgroundColor: kcVeryLightGrey,
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.camera_alt_outlined),
                                            onPressed: () {
                                              showAlertDialog(context,
                                                  provider.postProfilePic);
                                              // Handle edit button press
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                          }
                        }),
                    vSpace18,
                    FutureBuilder<String>(
                        future: Future.delayed(const Duration(seconds: 1),
                            () => 'One second has passed.'),
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
                                return Center(child: Text(snapshot.data!));
                              }
                              //if snapshot has error
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Something went wrong'));
                              }
                              //if snapshot is null
                              return const Center(child: Text('No data found'));
                          }
                        }),
                    InputField.dropdown(
                      hintText: "Blood Group",
                      dropDownValidator: (value) {
                        if (value == null) {
                          return "Please select your blood group";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        provider.bloodGroupController.text = value.toString();
                      },
                      items: dropdownList,
                    ),
                    InputField(
                      hintText: 'Address',
                      controller: provider.houseNameController,
                      validator: FormValidator.validate,
                    ),
                    InputField(
                      hintText: 'Location',
                      controller: provider.locationController,
                      validator: FormValidator.validate,
                    ),
                    Selector<ProfileFormProvider, List<District>>(
                      builder: (context, value, child) {
                        final dropdownList = value
                            .map((e) => DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text(e.district)))
                            .toList();
                        if (dropdownList.isEmpty) {
                          dropdownList.add(const DropdownMenuItem(
                              value: '0', child: Text('Loadding State...')));
                        }
                        return InputField.dropdown(
                            hintText: 'District',
                            dropDownValidator: (value) {
                              if (value == null) {
                                return "Please select a district";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              provider.districtController.text =
                                  value.toString();
                            },
                            items: dropdownList);
                      },
                      selector: (p0, p1) => p1.districts,
                    ),
                    FutureBuilder<List<StateAddress>>(
                      future: provider.getStates(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final dropdownList = snapshot.data
                              ?.map((e) => DropdownMenuItem(
                                  value: e.id, child: Text(e.state)))
                              .toList();
                          return InputField.dropdown(
                            intialValue: dropdownList?.first.value,
                            dropDownValidator: (value) {
                              if (value == null) return "Please select a State";
                              return null;
                            },
                            onChanged: (value) {
                              provider.stateController.text = value.toString();
                            },
                            items: dropdownList,
                            hintText: 'State',
                          );
                        }
                        return InputField.dropdown(
                          dropDownValidator: (value) {
                            if (value == null) return "Please select a state";
                            return null;
                          },
                          onChanged: ((p0) {}),
                          items: const [
                            DropdownMenuItem(
                                value: 0, child: Text('Loadding State...')),
                          ],
                          hintText: 'State',
                        );
                      },
                    ),
                    InputField(
                      hintText: 'Pincode',
                      controller: provider.pincodeController,
                      validator: FormValidator.validatePincode,
                    ),
                    vSpace25,
                    Selector<ProfileFormProvider, bool>(
                      builder: (context, value, child) {
                        return MyButton(
                          busy: value,
                          title: "Submit",
                          onTap: () {
                            provider.updateProfile();
                          },
                        );
                      },
                      selector: (p0, p1) => p1.isLoading,
                    )
                  ],
                ),
              )),
        ),
        Selector<ProfileFormProvider, bool>(
          selector: (_, provider) => provider.isBusy,
          builder: (_, isLoading, __) {
            return isLoading
                ? const Opacity(
                    opacity: 0.7,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  )
                : const SizedBox();
          },
        ),
        Selector<ProfileFormProvider, bool>(
          selector: (_, provider) => provider.isBusy,
          builder: (_, isLoading, __) {
            return isLoading
                ? Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          BodyText(
                            'Please wait... ',
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  showAlertDialog(
      BuildContext context, Future<void> Function(ImageSource) onTap) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Upload Image"),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () async {
                  MyRouter.pop();
                  onTap(ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(Icons.photo_size_select_actual_outlined),
                    hSpace5,
                    Text('Gallery')
                  ],
                )),
            const Divider(),
            TextButton(
                onPressed: () {
                  MyRouter.pop();
                  onTap(ImageSource.camera);
                },
                child: Row(
                  children: const [Icon(Icons.camera), hSpace5, Text('Camera')],
                )),
          ],
        ),
      ),
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

class ProfileFormProvider extends ChangeNotifier {
  bool isBusy = false;

  final personalFormKey = GlobalKey<FormState>();

  final bloodGroupController = TextEditingController();
  final houseNameController = TextEditingController();
  final locationController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  final booldGroups = ['A+', 'A-', 'AB+', 'AB-', 'B+', 'B-', 'O+', 'O-'];
  List<District> districts = [];

  String? profilePic;

  bool isLoading = false;

  final services = AccountServices();

  Future<void> postProfilePic(ImageSource imageSource) async {
    try {
      isBusy = true;
      notifyListeners();
      final status = await services.postProfilePic(imageSource);
      if (status == true) {
        Messenger.alert(msg: "Photo successfully uploaded", color: kcSuccess);
        await showProfilePic();
        notifyListeners();
      } else {
        Messenger.alert(msg: "Something went wrong", color: kcDanger);
      }
    } catch (e) {
      e;
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile() async {
    try {
      if (isLoading) return;
      if (!personalFormKey.currentState!.validate()) {
        return;
      }
      if (profilePic == null) {
        Messenger.alert(msg: "Please upload your photo", color: kcDanger);
        return;
      }
      final data = ProfileFormModel(
        bloodGroup: bloodGroupController.text,
        houseName: houseNameController.text,
        location: locationController.text,
        district: districtController.text,
        state: stateController.text,
        pincode: pincodeController.text,
      );
      isLoading = true;
      notifyListeners();


      final a = await services.postProfileDetails(data);

      if (a) {
        Messenger.alert(msg: "Profile Successfully Updated", color: kcSuccess);
        MyRouter.pushRemoveUntil(screen: const PersonalDetailsUpdateScreen());
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      Messenger.alert(msg: "Something went wrong", color: kcDanger);
      isLoading = false;
      notifyListeners();
      e;
    }
  }

  Future<List<StateAddress>> getStates() async {
    try {
      final data = await services.getAllStates();
      if (data.isEmpty) throw 'Service unawailabe now';
     
      stateController.text = data.first.id;
      await refreshDistrict(data.first.id);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshDistrict(String statecode) async {
    try {
      log(statecode);
      districts = await services.getAllDistricts('10');
      notifyListeners();
    } catch (e) {
      log(e.toString());
      e;
    }
  }

  Future<String> showProfilePic() async {
    try {
      final url = await services.getProilePicUrl();
      profilePic = url;
      return url.toString();
    } catch (e) {
      e;
      rethrow;
    } finally {
    }
  }
}
