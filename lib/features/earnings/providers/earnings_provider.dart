import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/earnings/models/earnings_details.dart';
import 'package:giro_driver_app/features/earnings/models/trip_history.dart';
import 'package:giro_driver_app/features/earnings/services/earnigs_services.dart';

class EarningsProviders extends ChangeNotifier {

  final _services = EarningsServices();
    final dobController = TextEditingController();

  var selectedDate = DateTime.now();
  void updateDate(DateTime date) {
    selectedDate = date;
    final dataString = "${date.toLocal()}".split(' ')[0];
    dobController.text = dataString;
    notifyListeners();
  }
  
  Future<RideHistory>  getEarningByDate() async{
    try {
     return await _services.getRideHistory(dobController.text);
    } catch (e) {
        e;
        rethrow;
    } finally {
    }
  }

  Future<EarningsDetails>  showEarningsDetails(String bookingId) async{
    try {
      return await  _services.getEarningsDetails(bookingId);
    } catch (e) {
        e;
        rethrow;
    } finally {
    }
  }
}