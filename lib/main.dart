import 'dart:async';
import 'dart:developer';  
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giro_driver_app/features/account/screens/payment_screen.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_form_screen.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/features/account/screens/vehicle_details_form_screen.dart';
import 'package:giro_driver_app/features/auth/providers/login_provider.dart';
import 'package:giro_driver_app/features/auth/providers/otp_login_provider.dart';
import 'package:giro_driver_app/features/auth/providers/signup_provider.dart';
import 'package:giro_driver_app/features/earnings/providers/earnings_provider.dart';
import 'package:giro_driver_app/features/home/providers/home_provider.dart';
import 'package:giro_driver_app/features/home/providers/main_screen_provider.dart';
import 'package:giro_driver_app/features/trips/provider/trip_provider.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/extensions/string_extensions.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/notification/notification_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';
import 'package:provider/provider.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.instance.initiNotification();

  await Firebase.initializeApp();

  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // NotificationSettings settings = await firebaseMessaging.requestPermission(
  //   alert: true,
  //   announcement: true,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: true,
  //   provisional: false,
  //   sound: true,
  // );

  // firebaseMessaging.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);
  // firebaseMessaging.setDeliveryMetricsExportToBigQuery(true);

  // final token = await FirebaseMessaging.instance.getToken();
  // log('=Token==================');
  // log(token.toString());
  // log('=Token==================');

  // print('User granted permission: ${settings.authorizationStatus}');

  // init bg services
  await initializeService('taskName');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => SignUpProvider()),
    ChangeNotifierProvider(create: (_) => ProfileFormProvider()),
    ChangeNotifierProvider(create: (_) => VehicleFormProvider()),
    ChangeNotifierProvider(create: (_) => OtpLoginProvider()),
    ChangeNotifierProvider(create: (_) => PaymentProvider()),
    ChangeNotifierProvider(create: (_) => ProfileDetailsUpdateProvider()),
    ChangeNotifierProvider(create: (_) => TripProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => MainScreenProvider()),
    ChangeNotifierProvider(create: (_) => EarningsProviders()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    log('>>>>>>>>........<<<<<<<<<');
    final a = await AwesomeNotifications().getInitialNotificationAction();
    log('>>>>>>>>........<<<<<<<<<');
    log(a.toString());
  
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (a != null) {
      log('>>>>>>>>........<<<<<<<<<');
      log(a.body.toString());
      if (a.payload?['type'] == 'new_booking') {
        // MyRouter.push(
        //     screen: NewBookingArrivalScreen(data: a.payload!));
      }
    }

    final token = await LocalNotification.getFirebaseMessagingToken();
    log(token);
    
  }

 

  @override
  void initState() {
    LocalNotification.initializeRemoteNotifications(debug: true);

    setupInteractedMessage();
    listenNotificationEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giro Driver',
      initialRoute: MyRoutes.init,
      routes: MyRoutes.routes,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: kcTransparent, elevation: 0),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: kcPrimarySwatch,
      ),
      scaffoldMessengerKey: Messenger.rootScaffoldMessengerKey,
      navigatorKey: MyRouter.navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}

/*=======================================================================
  get location on background
=======================================================================*/
Future<void> initializeService(String taskName) async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart
    ),
  );
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   log("Handling a background message: ${message.toMap()}");
//   log("Handling a background message: ${message.data}");

//   // await Noti.initialize(flutterLocalNotificationsPlugin);

//   // Noti.showBigTextNotification(body: 'New Msg',fln: flutterLocalNotificationsPlugin,title: 'Title',payload: '');

// }

late DatabaseReference newBookingRef;
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  //int dbCount = 0;
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final dio = await InterceptorHelper.getApiClient();
    await dio.post('driver-location-updates', data: {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  } catch (e) {
    log(e.toString());
    log('Error on getting location on onStart function');
  }

  Timer.periodic(
    const Duration(seconds: 5),
    (_) async {
    
      final bookingId = await SecuredStorage.instance.read('booking_id');
      log(bookingId ?? 'null');
      if (bookingId.isAvailable && bookingId != 'null') {
        newBookingRef =
            FirebaseDatabase.instance.ref('new_bookings/$bookingId');

        log(newBookingRef.key.toString());
        log(newBookingRef.path);

        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        log(position.latitude.toString());
        log(position.longitude.toString());
        log(DateTime.now().toLocal().toString());
        await newBookingRef.update({
          "d_lat": position.latitude,
          "d_lng": position.longitude,
        });
        log('new postion updated');
      }else{
        // service.stopSelf();
      }
    },
  );
}
