import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/home/models/ads_model.dart';
import 'package:giro_driver_app/features/home/models/user_model.dart';
import 'package:giro_driver_app/features/home/services/home_services.dart';

class HomeProvider extends ChangeNotifier {
  final services = HomeServices();

  Future<UserProfile?> showProfileDetails() async {
    try {
      return await services.getProfileDetails();
    } catch (e) {
      return null;
    }
  }

  // get ads
  Future<Ads> displayAds() async {
    try {
      return await services.getAds();
    } catch (e) {
      rethrow;
    }
  }

  bool isActive = false;
  bool isLoading = false;

  Future<void> changeStatus(bool status) async {
    try {
      isLoading = true;
      notifyListeners();

      final s = await services.setStatus(status);
      isActive = s;
      notifyListeners();
    } catch (e) {
      e;
    }finally
    {isLoading =false;
    notifyListeners();}
  }

  Future<void> getStatus() async {
    try {
       isLoading = true;
      notifyListeners();
      final s = await services.getStatus();
      isActive = s;
      notifyListeners();
    } catch (e) {
      e;
    }finally
    {isLoading =false;
    notifyListeners();}
  }

  Future<Map<String, dynamic>> getTodaysEarning() async {
    try {
      return await services.getTodaysEarnig();
    } catch (e) {
      return {"completed_rides": 0, "earnings": 0};
    }
  }
}
