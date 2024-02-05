import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/home/screens/home_screen.dart';
import 'package:giro_driver_app/features/trips/models/active_ride_details.dart';
import 'package:giro_driver_app/features/trips/provider/trip_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';

class NewBookingArrivalScreen extends StatefulWidget {
  const NewBookingArrivalScreen({Key? key, required this.data})
      : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<NewBookingArrivalScreen> createState() =>
      _NewBookingArrivalScreenState();
}

class _NewBookingArrivalScreenState extends State<NewBookingArrivalScreen> {
  int bookingStatus = 0;
  StreamSubscription<DatabaseEvent>? requestStream;

  Future<void> listenToBooking() async {
    try {
      DatabaseReference newBookingRef = FirebaseDatabase.instance
          .ref('new_bookings/${widget.data['booking_id']}');
        log('refCreated');
      requestStream = newBookingRef.onValue.listen((DatabaseEvent event) {
        final sanpshotData = event.snapshot.value;
        final data = sanpshotData as Map<dynamic, dynamic>;

        bookingStatus = data['status'];
        log('ref booksts $bookingStatus');

      });
      requestStream?.onData((event) {
        final sanpshotData = event.snapshot.value;
        final data = sanpshotData as Map<dynamic, dynamic>;

        bookingStatus = data['status'];
        log('ref booksts $bookingStatus');

        if (
        bookingStatus == TripStatus.tCANCELED ||
        bookingStatus == TripStatus.tREJECTED ||
        bookingStatus == TripStatus.tTIMEOUT ||
        bookingStatus == TripStatus.tCOMPLETED
        ) {
          requestStream?.cancel();
          requestStream = null;
           setState(() { 
        });
          return;
        }
        
       
      });
    } catch (e) {
      e;
    } 
  }
  @override
  void dispose() {
    requestStream?.cancel();
    super.dispose();
  }
  
  @override
  void initState() {
    getActiveRideDetails =context.read<TripProvider>(). getActiveRideDetails(
                      widget.data['booking_id'].toString());
    super.initState();
    log('initstate');
    listenToBooking();
  }
 late Future<ActiveRideDetails> getActiveRideDetails;
  
  @override
  Widget build(BuildContext context) {
    final provider = context.read<TripProvider>();
      log(bookingStatus.toString());
    return WillPopScope(
      onWillPop: () async {


          if (bookingStatus == TripStatus.tCANCELED ||
        bookingStatus == TripStatus.tREJECTED||
        bookingStatus == TripStatus.tTIMEOUT||
        bookingStatus == TripStatus.tCOMPLETED

        ) {
          log(bookingStatus.toString());
           MyRouter.pushRemoveUntil(screen: const HomeScreen());
        }

        if(bookingStatus == TripStatus.tPENDING){
          log(bookingStatus.toString());

          showRejectTripAlertDialog(
            context, widget.data['booking_id'].toString());
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Booking Details"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder<ActiveRideDetails>(
                  future: getActiveRideDetails,
                  // future: provider.getActiveRideDetails(
                  //     widget.data['booking_id'].toString()),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // indicating that the async operation has begun
                      case ConnectionState.waiting:
                        return const Center(child: Text('Loading..'));
                      // When async operation is completed.
                      case ConnectionState.done:
                      default:
                        //if snapshot has data
                        if (snapshot.hasData) {
                          final details = snapshot.data!.bookingDetails;
                        
                          final customer = snapshot.data!.customer;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1e000000),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            margin: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                vSpace18,
                                Text('From',
                                    style: bodyStyleBold.copyWith(
                                        color: Colors.black26)),
                                Text(details.fromLocation,
                                    style: heading3Style),
                                const Divider(),
                                Text(
                                  'To',
                                  style: bodyStyleBold.copyWith(
                                      color: Colors.black26),
                                ),
                                Text(details.toLocation, style: heading3Style),
                                const Divider(),
                                Text('Customer Name',
                                    style: bodyStyleBold.copyWith(
                                        color: Colors.black26)),
                                Text(customer.name, style: heading3Style),
                                const Divider(),
                                Text('Fare',
                                    style: bodyStyleBold.copyWith(
                                        color: Colors.black26)),
                                Text("₹ ${details.totalFare}",
                                    style: heading3Style),
                                vSpace25,
                                if(bookingStatus == TripStatus.tTIMEOUT )
                                  Column(
                                    children: [
                                      const Icon(Icons.info_outline,color: kcDanger,size: 50,),
                                      vSpace10,
                                      const Text('Request timed out',style: heading3Style,),
                                      vSpace10,
                                    MyButton( title: 'Exit to Home',onTap: () => MyRouter.pushRemoveUntil(screen:const HomeScreen()),)
                                    ],
                                  ) else if(bookingStatus == TripStatus.tCANCELED )
                                  Column(
                                    children: [
                                      const Icon(Icons.info_outline,color: kcDanger,size: 50,),
                                      vSpace10,
                                      const Text('Customer cancelled the ride.',style: heading3Style,),
                                      vSpace10,
                                    MyButton( title: 'Exit to Home',onTap: () => MyRouter.pushRemoveUntil(screen:const HomeScreen()),)
                                    ],
                                  )
                                else
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyButton(
                                        title: 'Accept',
                                        onTap: () {
                                          provider.acceptTrip(widget
                                              .data['booking_id']
                                              .toString());
                                        },
                                      ),
                                    ),
                                    hSpace18,
                                    Expanded(
                                      child: MyButton.outline(
                                        title: 'Reject',
                                        onTap: () {
                                          showRejectTripAlertDialog(
                                              context,
                                              widget.data['booking_id']
                                                  .toString());
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        //if snapshot has error
                        if (snapshot.hasError) {
                          return Text('Something went wrong ${snapshot.error}');
                        }
                        //if snapshot is null
                        return const Center(child: Text('No data found'));
                    }
                  }),
              const Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  showRejectTripReAlertDialog(String bookinId) {
    final context = MyRouter.navigatorKey.currentContext;
    final formKey = GlobalKey<FormState>();
    final reasons = [
      'On another ride',
      // 'Customer Misbehaviour',
      'Wrong trip details',
      'Poor vehicle condition',
    ];
    String reason = '';
    final dropdownList =
        reasons.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();

    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;
        await context?.read<TripProvider>().rejectTrip(bookinId, reason, true);
      },
    );

    // set up the button
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        MyRouter.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Select a reason"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select why do you want to cancel the trip?"),
            vSpace5,
            InputField.dropdown(
                hintText: 'Select a reason',
                dropDownValidator: (val) {
                  if (val == null) return "Please select a reason";
                  return null;
                },
                onChanged: (v) {
                  reason = v;
                },
                items: dropdownList),
          ],
        ),
      ),
      actions: [
        okButton,
        noButton,
      ],
    );

    // show the dialog
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  showRejectTripAlertDialog(BuildContext context, String bookinId) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        MyRouter.pop();

        showRejectTripReAlertDialog(bookinId);
        // context
        //     .read<TripProvider>()
        //     .rejectTrip(bookinId, 'Driver Rejected', false);
        // MyRouter.pop();
      },
    );

    // set up the button
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        MyRouter.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Cancel Trip?"),
      content: const Text("Are you sure, You want to cancel the trip?"),
      actions: [
        okButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
