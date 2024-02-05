
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/repo_services/account_serivces.dart';

class PersonalDetailsFormProvider extends ChangeNotifier {
  final personalDetailsFormKey = GlobalKey<FormState>();

  final bloodGroupController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeControler = TextEditingController();

  final services = AccountServices();

  //to update personal info
  Future<void> updatePersonalInfo() async {
    try {} catch (e) {
      rethrow;
    }
  }

  Future<void> myAsyncFunction() async {}
}


