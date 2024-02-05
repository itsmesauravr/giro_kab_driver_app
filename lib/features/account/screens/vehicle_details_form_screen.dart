import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/models/vehicle_category_model.dart';
import 'package:giro_driver_app/features/account/models/vehicle_type_model.dart';
import 'package:giro_driver_app/features/account/repo_services/account_serivces.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';

class VehicleDetailFormsScreen extends StatelessWidget {
  const VehicleDetailFormsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<VehicleFormProvider>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const BodyText.bold("Vehicle Details"),
          ),
          body: Form(
              key: provider.vehicleFormKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  vSpace18,
                  
                  FutureBuilder<List<VehicleCategory>>(
                    future: provider.showVehicleCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final dropdownList = snapshot.data
                            ?.map((e) => DropdownMenuItem(
                                value: e.id, child: Text(e.category)))
                            .toList();
                        return InputField.dropdown(
                          intialValue: dropdownList?.first.value,
                          dropDownValidator: (value) {
                            if (value == null) return "Please select a State";
                            return null;
                          },
                          onChanged: (value) {
                            provider.categoryController.text = value.toString();
                            provider.refreshVehicleType(value.toString());
                          },
                          items: dropdownList,
                          hintText: 'Vehicle Category',
                        );
                      }
                      return InputField.dropdown(
                        dropDownValidator: (value) {
                          if (value == null){
                            return "Please select a Vehicle Category";
                          }
                          return null;
                        },
                        onChanged: ((value) {
                          provider.refreshVehicleType(value);
                        }),
                        items: const [
                          DropdownMenuItem(
                              value: 0, child: Text('Loadding Vehicle Category...')),
                        ],
                        hintText: 'Vehicle Category',
                      );
                    },
                  ),
                  Selector<VehicleFormProvider, List<VehicleType>>(
                    builder: (context, value, child) {
                      final dropdownList = value
                          .map((e) => DropdownMenuItem(
                              value: e.id.toString(), child: Text(e.type)))
                          .toList();
                      if (dropdownList.isEmpty) {
                        dropdownList.add(const DropdownMenuItem(
                            value: '0', child: Text('Loadding Vehicle Type...')));
                      }
                      return InputField.dropdown(
                          intialValue: dropdownList.first.value,
                          hintText: 'Vehicle Type',
                          dropDownValidator: (value) {
                            if (value == null) return "Please select a Vehicle type";
                            return null;
                          },
                          onChanged: (value) {
                            provider.vehicleTypeController.text = value.toString();
                          },
                          items: dropdownList);
                    },
                    selector: (p0, p1) => p1.vehicleType,
                  ), 
                  vSpace25,

                   MyButton(
                        
                        title: "Submit",
                        onTap: () {
                          provider.updateVehicle();
                        },
                      ),
                   
                  
                ],
              )),
        ),
        Selector<VehicleFormProvider, bool>( 
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
        Selector<VehicleFormProvider, bool>(
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
}

class VehicleFormProvider extends ChangeNotifier {
  bool isBusy = false;

  final vehicleFormKey = GlobalKey<FormState>();

  final vehicleTypeController = TextEditingController();
  final categoryController = TextEditingController();

  List<VehicleType> vehicleType = [];

  bool isLoading = false;

  final services = AccountServices();

  Future<void> updateVehicle() async {
    try {
      if (isLoading) return;
      if (!vehicleFormKey.currentState!.validate()) {
        return;
      }
      isLoading = true;
      notifyListeners();

      final status = await services.postVehicleDetails({
        'vehicle_category': categoryController.text,
        'vehicle_type': vehicleTypeController.text
      });
      if (status == true) {
        Messenger.alert(
            msg: "Vehicle details successfully updated", color: kcSuccess);
            MyRouter.pushRemoveUntil(screen:const PersonalDetailsUpdateScreen());
      }
    } catch (e) {
      Messenger.alert(msg: "Something went wrong", color: kcDanger);

      e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<VehicleCategory>> showVehicleCategory() async {
    try {
       isLoading = true;
      notifyListeners();
      final data = await services.getVehicleCategory(); 
      if (data.isEmpty) throw 'Service unavailabe now';
      categoryController.text = data.first.id.toString(); 
      await refreshVehicleType(data.first.id.toString());
     
      return data;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace);
      rethrow;
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshVehicleType(String statecode) async {
    try {
       isLoading = true;
      notifyListeners();
      log(statecode);
      vehicleType = await services.getVehicleType(statecode);
      vehicleTypeController.text = vehicleType.first.id.toString();
      notifyListeners();
    } catch (e) {
      log(e.toString());
      e;
    }finally {
      isLoading = false;
      notifyListeners();
    } 
  }
}
