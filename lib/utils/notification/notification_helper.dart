import 'dart:async';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/home/screens/help_screen.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';

import '../../features/trips/screens/new_arrival_booking.dart';

// TO LISTEN NOTIFICATION EVENTS
@pragma('vm:entry-point')
Future<void> listenNotificationEvents() async {
  await AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
    onNotificationCreatedMethod: onNotificationCreatedMethod,
  );
}

// THIS FUNCTION WILL EXECUTE ON NOTIFICATION EVENTS
@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  log('[[[[[[[[[[[[message]]]]]]]]]]]]');
  log(receivedAction.body.toString());
  log(receivedAction.title.toString());
  log(receivedAction.payload.toString());
  log(receivedAction.channelKey.toString());
  log('[[[[[[[[[[[message]]]]]]]]]]]');

  if (receivedAction.payload?['type'] == 'new_booking') {
    MyRouter.push(
        screen: NewBookingArrivalScreen(data: receivedAction.payload!));
  }
}

// THIS FUNCTION WILL EXECUTE ON NOTIFICATION EVENTS
@pragma('vm:entry-point')
Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedAction) async {
  log('[[[[[[[[[[[[message]]]]]]]]]]]]');
  log(receivedAction.body.toString());
  log(receivedAction.title.toString());
  log(receivedAction.payload.toString());
  log(receivedAction.channelKey.toString());
  log('[[[[[[[[[[[message]]]]]]]]]]]');

  if (receivedAction.payload?['type'] == 'new_booking') {
    MyRouter.push(
        screen: NewBookingArrivalScreen(data: receivedAction.payload!));
  }
}

class LocalNotification {
  // making LocalNotification class singleton
  LocalNotification._internal();
  static LocalNotification instance = LocalNotification._internal();
  factory LocalNotification() => instance;

  // INITIALIZATION
  Future<void> initiNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/launcher_icon',
      [
        NotificationChannel(
            channelGroupKey: 'ride',
            channelKey: 'new_bookings',
            channelName: 'Ride notifications',
            channelDescription: 'Notification channel for rides',
            channelShowBadge: true,
            importance: NotificationImportance.High,
            enableVibration: false,
            playSound: true,
            soundSource: 'resource://raw/res_custom_notification'),
      ],
    );
  }

  ///  *********************************************
  ///     INITIALIZATION FCM METHODS
  ///  *********************************************

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: mySilentDataHandle,
        onFcmTokenHandle: myFcmTokenHandle,
        onNativeTokenHandle: myNativeTokenHandle,
        licenseKeys: [
          'BbLkI7u8bN39rupG26LJKOpE3RrhE/O82z5LQashjE6IyqCBcDUH4vloa2NHepe0YBHGwre+HTqkt1KvncMGP9JgbWbmAILz5w3Oclm/zYbyGoRyw8D2gRZg4RuSreYooqdOJR87A9Ye7FGnCIC8cJl888xazzCOoX9c4n5Th0g=',
          'QQ65DaZXWdTcx2v5Cd8/vTQH+XgQRnQSE1TibJiYOy+NaUIDlmy+X6FouuBhARtsNnX/X5AU0g+4TjrWryUiNkEMx+vdqmMncDp+/+E7h6ZKLqy+YL72f6wEMs7LGFL22CnFZHQwlXeibudCsacPU5VX87BjCjNG4x1Sj42mZrM=',
        ],
        debug: debug);
  }

  // Request FCM token to Firebase
  static Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return firebaseAppToken;
  }

}

//  *********************************************
///     REMOTE NOTIFICATION EVENTS
///  *********************************************

/// Use this method to execute on background when a silent data arrives
/// (even while terminated)
@pragma("vm:entry-point")
Future<void> mySilentDataHandle(FcmSilentData silentData) async {
  log('"SilentData": ${silentData.toString()}');

  if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
    log("bg");
  } else {
    log("FOREGROUND");
  }
}

/// Use this method to detect when a new fcm token is received
@pragma("vm:entry-point")
Future<void> myFcmTokenHandle(String token) async {
  debugPrint('FCM Token:"$token"');
}

/// Use this method to detect when a new native token is received
@pragma("vm:entry-point")
Future<void> myNativeTokenHandle(String token) async {
  debugPrint('Native Token:"$token"');
}
