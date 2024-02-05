import 'package:giro_driver_app/features/home/models/ads_model.dart';
import 'package:giro_driver_app/features/home/models/user_model.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/geolocator/geolocator_helper.dart';

class HomeServices {

  Future<UserProfile>  getProfileDetails() async{
    try {
       final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-profile-details');
      if (res.statusCode == 200) {
        return UserProfile.fromJson(res.data);
      }
      throw 'No ads found';
    } catch (e) {
        rethrow;
    } 
  }
  /// get ads
  Future<Ads> getAds() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-ads');
      if (res.statusCode == 200) {
        return Ads.fromJson(res.data);
      }
      throw 'No ads found';
    } catch (e) {
      e;
      rethrow;
    } 
  }

  Future<bool> setStatus(bool status) async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final pos = await GeoLocationService.determinePosition();
      if (status) {
        final res = await dio.post('driver-availability-on',
            data: {'latitude': pos.latitude, 'longitude': pos.longitude});
        if (res.statusCode == 200) {
          return true;
        }
      } else {
        final res = await dio.post('driver-availability-off',
            data: {'latitude': pos.latitude, 'longitude': pos.longitude});
        if (res.statusCode == 200) {
          return false;
        }
      }
      return true;
    } catch (e) {
      e;
      return true;
    } finally {
      // print('completed');
    }
  }

  Future<bool> getStatus() async {
    try {
      final dio = await InterceptorHelper.getApiClient();

      final res = await dio.get('driver-availability');
      if (res.statusCode == 200) {
        if (res.data['status'] == '1' || res.data['status'] == 1) return true;
      }
      return false;
    } catch (e) {
      e;
      return true;
    } finally {
      
    }
  }

  Future<Map<String, dynamic>> getTodaysEarnig() async {
    try {
      final dio = await InterceptorHelper.getApiClient();

      final res = await dio.get('driver-todays-earnings');
      if (res.statusCode == 200) {
        return res.data;
      }
      return {"completed_rides": 0, "earnings": 0};
    } catch (e) {
      e;
      return {"completed_rides": 0, "earnings": 0};
    } finally {
     
    }
  }
}
