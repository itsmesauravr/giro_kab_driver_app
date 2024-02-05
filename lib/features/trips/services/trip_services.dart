
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giro_driver_app/features/trips/models/active_ride_details.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/extensions/string_extensions.dart';
import 'package:giro_driver_app/utils/geolocator/geolocator_helper.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';

class TripServices {
  final storage = SecuredStorage.instance;

  Future<Map<String,dynamic>?> getCurrentActiveRide() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-running-ride');

      if (res.statusCode == 200) {
        return res.data["ride_det"];
      }
     
      return null;
    } catch (e) {
      if(e is DioError){
         if(e.response?.statusCode == 408){
        await SecuredStorage.instance.delete('booking_id');
      }
      }
      e;
      return null;
    } finally {
      // print('completed');
    }
  }

  Future<void> setDriverState(String value) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final dio = await InterceptorHelper.getApiClient();
      // final res =
       await dio.post('driver-availability-update', data: {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<void> postCancelTrip(
      String bookingId, String reason, bool delete) async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      // final res = 
      await dio.post('reject-booking', data: {
        'booking_id': bookingId,
        'rejection_reason': reason,
      });

      if (delete) {
        await SecuredStorage.instance.delete('booking_id');
      }
    } catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<void> acceptTripRequest(String bookingId) async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.post('accept-booking', data: {
        'booking_id': bookingId,
      });
      res;
      await SecuredStorage.instance.write('booking_id', bookingId);
      updateCurrentLocation();
    } catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<void> startTripRequest() async {
    try {
      final bookingId = await SecuredStorage.instance.read('booking_id');

      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.post('start-journey', data: {
        'booking_id': bookingId,
      });
      res;
    } catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<void> completeTripRequest(
      String extraCharge, String waitingCharge, String paymentType) async {
    try {
      final bookingId = await SecuredStorage.instance.read('booking_id');

      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.post('complete-journey', data: {
        'booking_id': bookingId,
        'extra_ride_fee': extraCharge,
        'waiting_charge': waitingCharge,
        'payment_type': paymentType
      });
      if (res.statusCode == 200) {
        await SecuredStorage.instance.delete('booking_id');
      }
    } catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<void> delete() async {
    try {} catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<void> updateCurrentLocation() async {
    try {
      final position = await GeoLocationService.determinePosition();

      final dio = await InterceptorHelper.getApiClient();
      // final res =
       await dio.post('driver-location-updates', data: {
        'latitude': position.latitude,
        'longitude': position.longitude
      });
    } catch (e) {
      e;
    } finally {
      // print('completed');
    }
  }

  Future<ActiveRideDetails> getActiveRideDetails(String? bookingId) async {
    try {
      bookingId ??= await SecuredStorage.instance.read('booking_id');
      if (bookingId.isAvailable && bookingId != 'null') {
        final dio = await InterceptorHelper.getApiClient();
        final res = await dio.get('driver-active-ride/$bookingId');

        if (res.statusCode == 200) {
          return ActiveRideDetails.fromJson(res.data);
        }
      }
      throw 'No trip details found';
    } catch (e) {
      e;
      rethrow;
    } finally {
      // print('completed');
    }
  }
}
