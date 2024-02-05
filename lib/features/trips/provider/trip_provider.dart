import 'dart:async';
import 'dart:developer';
import 'dart:math' as maths;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:giro_driver_app/features/home/screens/home_screen.dart';
import 'package:giro_driver_app/features/trips/screens/maps_screen.dart';
import 'package:giro_driver_app/features/trips/screens/new_arrival_booking.dart';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/trips/models/active_ride_details.dart';
import 'package:giro_driver_app/features/trips/services/trip_services.dart';
import 'package:giro_driver_app/utils/extensions/string_extensions.dart';
// import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripProvider extends ChangeNotifier {
  // StreamSubscription<QuerySnapshot> requestStream;

  final services = TripServices();

  Future<void> setDriverActiveState(String value) async {
    try {
      await SecuredStorage.instance.write('isDriverActive', value);
    } catch (e) {
      e;
    } 
  }

  Future<bool> getDriverActiveState(String value) async {
    try {
      final state = await SecuredStorage.instance.read('isDriverActive');

      if (state.isAvailable && state == 'true') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } 
  }

  Future<void> rejectTrip(String bookingId, String reason, bool delete) async {
    try {
      await services.postCancelTrip(bookingId, reason, delete);
      // Messenger.alert(msg: 'Trip Rejected');
      MyRouter.pushRemoveUntil(screen: const HomeScreen());
    } catch (e) {
      e;
    }
  }

  Future<void> startTrip() async {
    try {
      log('TRIP START REQUEST');
      await services.startTripRequest();
      // Messenger.alert(msg: 'Trip started');
    } catch (e) {
      e;
    } 
  }

  Future<void> completetTrip(String extraCharge, String waitingCharge, String paymentType) async {
    try {
      await services.completeTripRequest(extraCharge, waitingCharge, paymentType);
      // Messenger.alert(msg: 'Trip completed');
      MyRouter.pushRemoveUntil(screen: const HomeScreen());
    } catch (e) {
      e;
    } finally {
      log('completed');
    }
  }

  Future<void> checkForCurrentActiveRide() async {
    try {
      final bookingId = await services.getCurrentActiveRide();
      if (bookingId == null) return;
      if(bookingId['status'] == 0){
        MyRouter.push(screen: NewBookingArrivalScreen(data: {'booking_id' : bookingId['id'].toString(), 'status': 0}));
        return;
      }
      await SecuredStorage.instance.write('booking_id', bookingId['id'].toString());
      gotoMapsScreen(bookingId['id'].toString());
    } catch (e) {
      e;
    } 
  }

  StreamSubscription<DatabaseEvent>? requestStream;
  int? rideStatus;
  String? paymentStatus;

  Future<void> acceptTrip(String bookingId) async {
    try {
      await services.acceptTripRequest(bookingId);
      // Messenger.alert(msg: 'Accepted');

      gotoMapsScreen(bookingId);
    } catch (e) {
      e;
    } finally {
      log('completed acceptTrip');
    }
  }

  Future<void> gotoMapsScreen(String bookingId) async {
    try {
      log('\n \n Going to Maps Screen \n \n');
      DatabaseReference newBookingRef =
          FirebaseDatabase.instance.ref('new_bookings/$bookingId');

      requestStream = newBookingRef.onValue.listen((DatabaseEvent event) {
        final sanpshotData = event.snapshot.value;
        final data = sanpshotData as Map<dynamic, dynamic>;
        log('===From first Listen============');
        log(data.toString());
        rideStatus = data['status'];
        paymentStatus = data['payment_status']?.toString();
        log(rideStatus.toString());
        notifyListeners();
      });

      requestStream?.onData((event) {
        final sanpshotData = event.snapshot.value;
        final data = sanpshotData as Map<dynamic, dynamic>;

        rideStatus = data['status'];
        paymentStatus = data['payment_status']?.toString();

        if (rideStatus == TripStatus.tCANCELED) {
          requestStream?.cancel();
          requestStream = null;
          notifyListeners();

          return;
        }
        if (rideStatus == TripStatus.tREJECTED) {
          requestStream?.cancel();
          requestStream = null;
          notifyListeners();
          return;
        }
        if (rideStatus == TripStatus.tTIMEOUT) {
          requestStream?.cancel();
          requestStream = null;
          notifyListeners();

          return;
        }
        if (rideStatus == TripStatus.tCOMPLETED) {
          requestStream?.cancel();
          requestStream = null;
          notifyListeners();

          return;
        }
        _getPolyPoints(data['points'].toString());
        _getDriverPolyPoints(data['start_points'].toString());
        sourceLocation = polylineCoordinates.first;
        destination = polylineCoordinates.last;
        notifyListeners();
        log('===blah blah blah============');
        log("ride Status ${rideStatus.toString()}");
        log("data ${data.toString()}");
        log('===blah blah blah============');
      });
      MyRouter.pushReplace(screen: const MapsScreen());
    } catch (e) {
      e;
    } 
  }

  Future<ActiveRideDetails> getActiveRideDetails(String? bookingId) async {
    try {
      // print('object $bookingId');
      return await services.getActiveRideDetails(bookingId);
    } catch (e) {
      e;
      rethrow;
    } 
  }

/*=======================================================================
  MAPS PROPS
=======================================================================*/

  // static const YOUR_API_KEY = 'AIzaSyAV9nmFBGBHAJ8OsNg1XhGNmoftJXBdyqQ';
  static const baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  static LatLng? sourceLocation; // kannur
  static LatLng? destination;
  final List<LatLng> travelled = [];
  final List<Marker> _markers = <Marker>[];
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
    BitmapDescriptor destinationLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor originLocationIcon = BitmapDescriptor.defaultMarker;
  Animation<double>? _animation;
  late TickerProvider tickerProvider;
  final _mapMarkerSC = StreamController<List<Marker>>.broadcast();
  // StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream =>
      _mapMarkerSC.stream.asBroadcastStream();

  List<LatLng> polylineCoordinates = [];

  void _getPolyPoints(String encodedLines) async {
    log('started getpolypoints');
    PolylinePoints polylinePoints = PolylinePoints();

    /// from string
    List<PointLatLng> lines = polylinePoints.decodePolyline(encodedLines);

    if (lines.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in lines) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      log('POLYLINE LENGTH  ${polylineCoordinates.length}');
      notifyListeners();
    }

    // print('completed getpolypoints');
  }

  void setCustomMarkerIcon() {
    String iconPath = "assets/icons/car-top-view.png";
   
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, iconPath)
        .then((icon) {
      currentLocationIcon = icon;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icons/destination_mark.png')
        .then((icon) {
      destinationLocationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icons/pick.png')
        .then((icon) {
      originLocationIcon = icon;
    });
  }

  List<LatLng> drivePolylineCoordinates = [];

  void _getDriverPolyPoints(String encodedLines) async {
    log('GetDriverPolylines');
    PolylinePoints polylinePoints = PolylinePoints();

    /// from string
    List<PointLatLng> lines = polylinePoints.decodePolyline(encodedLines);

    if (lines.isNotEmpty) {
      drivePolylineCoordinates.clear();
      for (var point in lines) {
        drivePolylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      log("DRIVER POLYLINE LENGTH ${drivePolylineCoordinates.length}");
      notifyListeners();
    }
  }

  /// Animate Car
  void animateCar(
    double fromLat, //Starting latitude
    double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    StreamSink<List<Marker>>
        mapMarkerSink, //Stream build of map to update the UI
    TickerProvider
        provider, //Ticker provider of the widget. This is used for animation
    // GoogleMapController controller, //Google map controller of our widget
  ) async {
    final double bearing =
        _getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    _markers.clear();

    var carMarker = Marker(
      markerId: const MarkerId("driverMarker"),
      position: LatLng(fromLat, fromLong),
      // icon: BitmapDescriptor.fromBytes(
      //     await getBytesFromAsset('asset/car.png', 60)),
      anchor: const Offset(0.5, 0.5),
      flat: true,
      rotation: bearing,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    //Adding initial marker to the start location.
    _markers.add(carMarker);
    mapMarkerSink.add(_markers);

    final animationController = AnimationController(
      duration:
          const Duration(milliseconds: 1000), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        //We are calculating new latitude and printitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (_markers.contains(carMarker)) _markers.remove(carMarker);

        //New marker location
        carMarker = Marker(
            markerId: const MarkerId("driverMarker"),
            position: newPos,
            icon: currentLocationIcon,
            // icon: BitmapDescriptor.fromBytes(
            //     await getBytesFromAsset('asset/icons/ic_car_top_view.png', 50)),
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            draggable: false);

        //Adding new marker to our list and updating the google map UI.
        _markers.add(carMarker);
        mapMarkerSink.add(_markers);
      });

    //Starting the animation
    animationController.forward();
  }

  double _getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(maths.atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - degrees(maths.atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return degrees(maths.atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - degrees(maths.atan(lng / lat))) + 270;
    }
    return -1;
  }
}

class TripStatus {
  static const tPENDING = 0;
  static const tACCEPTED = 1;
  static const tREJECTED = 2;
  static const tCANCELED = 3;
  static const tTIMEOUT = 4;
  static const tSTARTED = 5;
  static const tCOMPLETED = 6;
}
