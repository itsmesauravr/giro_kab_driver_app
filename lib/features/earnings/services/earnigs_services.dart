import 'dart:developer';

import 'package:giro_driver_app/features/earnings/models/earnings_details.dart';
import 'package:giro_driver_app/features/earnings/models/trip_history.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';

class EarningsServices {
  
  Future<RideHistory>  getRideHistory(String date) async{
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.post('driver-datewise-rides', data: {
        'ride_date': date,
        
      });
      if(res.statusCode == 200){
        return RideHistory.fromJson(res.data);
      }
      throw 'Unknown Error while loading ride history';
    } catch (e) {

        log(e.toString());
        rethrow;
    } finally {
        // print('completed');
    }
  }

  Future<EarningsDetails>  getEarningsDetails(String bookingId) async{
    try {
      final dio = await InterceptorHelper.getApiClient();
      log(bookingId);
      final res = await dio.get('driver-ride-history/$bookingId');
      if(res.statusCode == 200){
        return EarningsDetails.fromJson(res.data);
      }
      throw 'Unknown Error while loading ride history';
    } catch (e) {
        e;
        rethrow;
    } finally {
        // print('completed');
    }
  }
}