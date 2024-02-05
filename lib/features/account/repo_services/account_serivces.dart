import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:giro_driver_app/features/account/models/district_model.dart';
import 'package:giro_driver_app/features/account/models/profile_form_model.dart';
import 'package:giro_driver_app/features/account/models/profile_status_model.dart';
import 'package:giro_driver_app/features/account/models/state_model.dart';
import 'package:giro_driver_app/features/account/models/vehicle_category_model.dart';
import 'package:giro_driver_app/features/account/models/vehicle_type_model.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/img_picker/img_picker.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';

class AccountServices {
  Future<void> logoutDriver() async {
      final storage = SecuredStorage.instance;

    try {
      final dio = await InterceptorHelper.getApiClient();
      await dio.get('driver-logout');
    } catch (e) {
      e;
    } finally {
      await storage.delete('accessToken');
    }
  }

  Future<bool> postProfilePic(ImageSource imageSource) async {
    try {
      final file = await ImgPicker().pickImage(source: imageSource);
      if (file == null) return false;

      final dio = await InterceptorHelper.getApiClient();

      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'img': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await dio.post('driver-profile-photo', data: formData);
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      e;
      rethrow;
    } finally {
    }
  }

  // get profile status
  static Future<ProfileStatus> getProfileStatus() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-profile-uploads');
      if (res.statusCode == 200) {
        return ProfileStatus.fromJson(res.data);
      }
      throw '';
    } catch (e) {
      rethrow;
    }
  }

  // Profile page services
  Future<String?> getProilePicUrl() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-profile-photo');
      if (res.statusCode == 200) {
        log(res.data.toString());
        log('from service');
        return res.data['photo'];
      }
      throw 'no data';
    } catch (e) {
      e;
      rethrow;
    } finally {
    }
  }

  /// to post profile details with dio
  Future<bool> postProfileDetails(ProfileFormModel data) async {
    try {
      log('fasfsdfdsfsdfdsfasdfasdfasdfasfsdfa');
      final dio = await InterceptorHelper.getApiClient();
      log(data.toJson().toString());
      final res =
          await dio.post('driver-personal-details', data: data.toJson());
      log(res.data.toString());
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());

      rethrow;
    }
  }

  // get all states availabe
  Future<List<StateAddress>> getAllStates() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('all-states');
      if (res.statusCode == 200) {
        return List<StateAddress>.from(
            res.data["state"].map((x) => StateAddress.fromJson(x)));
      }
      throw '';
    } catch (e) {
      rethrow;
    }
  }

  // get all district available under a state
  Future<List<District>> getAllDistricts(String stateCode) async {
    try {

      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('all-districts/$stateCode');
      if (res.statusCode == 200) {

        return List<District>.from(
            res.data["districts"].map((x) => District.fromJson(x)));
      }
      throw '';
    } catch (e) {
      rethrow;
    }
  }

  // get vehicle category
  Future<List<VehicleCategory>> getVehicleCategory() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('vehicle-categories');
      if (res.statusCode == 200) {
        log(res.data.toString());
        return List<VehicleCategory>.from(
            res.data["categories"].map((x) => VehicleCategory.fromJson(x)));
      }
      throw "";
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
    }
  }

  // get vehicle type
  Future<List<VehicleType>> getVehicleType(String categoryCode) async {
    try {

      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('vehicle-types/$categoryCode');
      if (res.statusCode == 200) {
       
        return List<VehicleType>.from(
            res.data["types"].map((x) => VehicleType.fromJson(x)));
      }
      throw '';
    } catch (e) {
     
      rethrow;
    }
  }

  Future<bool> postVehicleDetails(Map<String, dynamic> data) async {
    try {
      log('fasfsdfdsfsdfdsfasdfasdfasdfasfsdfa');
      log(data.toString());
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.post('driver-vehicle-details', data: data);
      log(res.data.toString());
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //final submission
  Future<void>  finalSubmission() async{
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-profile-submission');
      if(res.statusCode==200){

      }
    } catch (e) {

        e;
        rethrow;
    } finally {
        log('completed');
    }
  }
}
