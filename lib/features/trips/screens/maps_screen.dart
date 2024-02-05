import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/home/screens/home_screen.dart';
import 'package:giro_driver_app/features/trips/models/active_ride_details.dart';
import 'package:giro_driver_app/features/trips/provider/trip_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    context.read<TripProvider>().tickerProvider = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TripProvider>();

    // provider.getDirections();
    return WillPopScope(
      onWillPop: () async {
        if (provider.rideStatus == TripStatus.tREJECTED) {
          MyRouter.pushRemoveUntil(screen: const HomeScreen());
          return false;
        }
        if (provider.rideStatus == TripStatus.tCOMPLETED) {
          MyRouter.pushRemoveUntil(screen: const HomeScreen());
          return false;
        }
        if (provider.rideStatus == TripStatus.tCANCELED) {
          MyRouter.pushRemoveUntil(screen: const HomeScreen());
          return false;
        }
        if (provider.rideStatus == TripStatus.tTIMEOUT) {
          MyRouter.pushRemoveUntil(screen: const HomeScreen());
          return false;
        }
        if (provider.rideStatus == null) {
          MyRouter.pushRemoveUntil(screen: const HomeScreen());
          return false;
        }
        final bookingId = await SecuredStorage.instance.read('booking_id');
        await showRejectTripAlertDialog(bookingId.toString());
        return false;
      },
      child: Scaffold(
          body: SafeArea(
            child: Stack(
                  children: [
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight - (constraints.maxHeight / 4),
                child: Consumer<TripProvider>(
                  builder: (context, value, child) {
                    return StreamBuilder<List<Marker>>(
                        stream: provider.mapMarkerStream,
                        builder: (context, snapshot) {
                          Set<Marker> markers = {};
                          if (TripProvider.destination != null &&
                              TripProvider.sourceLocation != null) {
                            markers = {
                              Marker(
                                  markerId: const MarkerId("source"),
                                  position: TripProvider.sourceLocation!,
                                  icon: provider.originLocationIcon),
                              Marker(
                                  markerId: const MarkerId("destination"),
                                  position: TripProvider.destination!,
                                  icon: provider.destinationLocationIcon),
                            };
                          }
                          return GoogleMap(
                              myLocationEnabled: true,
                              markers: {
                                ...markers,
                                ...Set<Marker>.of(snapshot.data ?? [])
                              },
                              polylines: {
                                Polyline(
                                    polylineId: const PolylineId("route"),
                                    points: provider.polylineCoordinates,
                                    color: const Color(0xFF8A59A3),
                                    width: 4),
                                Polyline(
                                    polylineId: const PolylineId("driver"),
                                    points: provider.drivePolylineCoordinates,
                                    color: const Color.fromARGB(255, 39, 39, 39),
                                    width: 3),
                              },
                              initialCameraPosition: const CameraPosition(
                                  zoom: 13,
                                  target: LatLng(11.874477, 75.370369)));
                        });
                  },
                ),
              );
            }),
            Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: kcDark,
                    ),
                    onPressed: () async {
                      if (provider.rideStatus == TripStatus.tREJECTED) {
                        MyRouter.pushRemoveUntil(screen: const HomeScreen());
                        return;
                      }
                      if (provider.rideStatus == TripStatus.tCOMPLETED) {
                        MyRouter.pushRemoveUntil(screen: const HomeScreen());
                        return;
                      }
                      if (provider.rideStatus == TripStatus.tCANCELED) {
                        MyRouter.pushRemoveUntil(screen: const HomeScreen());
                        return;
                      }
                      if (provider.rideStatus == TripStatus.tTIMEOUT) {
                        MyRouter.pushRemoveUntil(screen: const HomeScreen());
                        return;
                      }
                      if (provider.rideStatus == null) {
                        MyRouter.pushRemoveUntil(screen: const HomeScreen());
                        return;
                      }
                      final bookingId =
                          await SecuredStorage.instance.read('booking_id');
                      await showRejectTripAlertDialog(bookingId.toString());
                    },
                  ),
                )),
            DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.25,
              maxChildSize: 1,
              snapSizes: const [0.5, 1],
              snap: true,
              builder: (context, scrollController) {
                log(provider.rideStatus.toString());
                Future<ActiveRideDetails> d =
                    provider.getActiveRideDetails(null);
                return Container(
                  color: const Color(0xFFFFFFFF),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        vSpace10,
                        Container(
                          height: 8,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1e000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: Colors.black12,
                          ),
                        ),
                        FutureBuilder<ActiveRideDetails>(
                            future: d,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                // indicating that the async operation has begun
                                case ConnectionState.waiting:
                                  return const LinearProgressIndicator();
                                // When async operation is completed.
                                case ConnectionState.done:
                                default:
                                  //if snapshot has data
                                  if (snapshot.hasData) {
                                    final data = snapshot.data!;
                                    log('==-=-==++++++-=[[[[[[[[[]]]]]]]]]');
                                    log(data.toString());
                                    return Selector<TripProvider, int?>(
                                        selector: (p0, p1) => p1.rideStatus,
                                        builder: (context, value, _) {
                                          return Container(
                                            margin: const EdgeInsets.all(8.0),
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x1e000000),
                                                  blurRadius: 16,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: Column(children: [
                                              ListTile(
                                                  title: BodyText.bold(
                                                      data.customer.name),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (provider.rideStatus ==
                                                          TripStatus.tACCEPTED)
                                                        const Text(
                                                            'Ride Accepted')
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tREJECTED)
                                                        const Text(
                                                            'Ride Rejected')
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tTIMEOUT)
                                                        const Text(
                                                            'Request Timeout')
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tPENDING)
                                                        const Text(
                                                            'Waiting for driver to respond')
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tSTARTED)
                                                        const Text(
                                                            'Ride Started')
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tCOMPLETED)
                                                        const Text(
                                                            'Ride Completed')
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tCANCELED)
                                                        const Text(
                                                            'Ride Cancelled'),
                                                    ],
                                                  ),
                                                  trailing: Column(
                                                    children: [
                                                      if (provider.rideStatus ==
                                                          TripStatus.tACCEPTED)
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      kcPrimary)),
          
                                                          // onPressed: provider
                                                          //     .startTrip,
                                                          onPressed: () =>
                                                              showTripStartAlertDialog(
                                                                  context),
                                                          child: Text(
                                                            'START',
                                                            style: bodyStyleBold
                                                                .copyWith(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        )
                                                      else if (provider
                                                              .rideStatus ==
                                                          TripStatus.tSTARTED)
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      kcPrimary)),
                                                          onPressed: () =>
                                                              showTripCompleteAlertDialog(
                                                                  context),
                                                          child: Text(
                                                            'Complete',
                                                            style: bodyStyleBold
                                                                .copyWith(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ),
                                                    ],
                                                  )),
                                              // vSpace50,
                                              if (provider.rideStatus ==
                                                  TripStatus.tPENDING)
                                                const LinearProgressIndicator(),
                                              const Divider(
                                                height: 15,
                                              ),
                                              // Second Block
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/icons/location_marker_icon.png'),
                                                    hSpace10,
                                                    BodyText(
                                                        "${data.bookingDetails.distance} KM"),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Image.asset(
                                                        'assets/icons/clock_icon.png'),
                                                    hSpace10,
                                                    BodyText(data
                                                        .bookingDetails.time),
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                              // Fare Block
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    const BodyText('Fare'),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: const Color(
                                                            0xfffff7e5),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 7,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/icons/wallet_icon_primary.png'),
                                                          hSpace10,
                                                          BodyText.bPrimary(data
                                                              .bookingDetails
                                                              .totalFare
                                                              .toString()),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                              // pay status block
                                              Selector<TripProvider, String?>(
                                                  selector: (p0, p1) =>
                                                      p1.paymentStatus,
                                                  builder: (context, val, _) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Row(
                                                        children: [
                                                          const BodyText(
                                                              "Payment Status"),
                                                          hSpace18,
                                                          const Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          provider.paymentStatus !=
                                                                  '1'
                                                              ? Text("Not Paid",
                                                                  style: bodyStyle
                                                                      .copyWith(
                                                                          color:
                                                                              kcInfo))
                                                              : Text(
                                                                  "Paid",
                                                                  style: bodyStyle
                                                                      .copyWith(
                                                                          color:
                                                                              kcSuccess),
                                                                ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                              const Divider(),
                                              ListTile(
                                                title: BodyText.bold(data
                                                    .bookingDetails
                                                    .fromLocation),
                                                leading: CircleAvatar(
                                                  child: Image.asset(
                                                      'assets/icons/gps_avatar.png'),
                                                ),
                                              ),
                                              ListTile(
                                                  title: BodyText.bold(data
                                                      .bookingDetails
                                                      .toLocation),
                                                  leading: CircleAvatar(
                                                    child: Image.asset(
                                                        'assets/icons/gps_avatar.png'),
                                                  )),
                                            ]),
                                          );
                                        });
                                  }
                                  //if snapshot has error
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            'Something went wrong ${snapshot.error}'));
                                  }
                                  //if snapshot is null
                                  return const Center(
                                      child: Text('No data found'));
                              }
                            })
                      ],
                    ),
                  ),
                );
              },
            )
                  ],
                ),
          )),
    );
  }

  showRejectTripAlertDialog(String bookinId) {
    final context = MyRouter.navigatorKey.currentContext;
    final formKey = GlobalKey<FormState>();
    final reasons = [
      'On another ride',
      'Customer Misbehaviour',
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
      title: const Text("Cancel Trip?"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure, You want to cancel the trip?"),
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

  showTripCompleteAlertDialog(BuildContext context) {
    final provider = context.read<TripProvider>();
    final extraChageController = TextEditingController();
    final waitingController = TextEditingController();
    final reasons = [
      {'type': 'Offline', 'value': '2'},
    ];
    String? paymentType = provider.paymentStatus == '1' ? '1' : null;
    final formKey = GlobalKey<FormState>();
    final dropdownList = reasons
        .map((e) => DropdownMenuItem(
            value: e['value'], child: Text(e['type'].toString())))
        .toList();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Complete Trip"),
      content: SizedBox(
          child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            paymentType == '1'
                ? vSpace5
                : InputField.dropdown(
                    hintText: 'Select payment type',
                    dropDownValidator: (val) {
                      if (val == null) return "Please select payment type";
                      if (paymentType == null) {
                        return "Please select payment type";
                      }
                      return null;
                    },
                    onChanged: (v) {
                      paymentType = v;
                    },
                    items: dropdownList),
            InputField(
              inputType: TextInputType.number,
              labelText: "Extra Charge",
              hintText: "Extra Charge",
              controller: extraChageController,
            ),
            InputField(
              inputType: TextInputType.number,
              labelText: "Waiting Charge",
              hintText: "Waiting Charge",
              controller: waitingController,
            ),
            MyButton(
              title: "Submit",
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                provider.completetTrip(extraChageController.text,
                    waitingController.text, paymentType!);

                MyRouter.pop();
              },
            ),
          ],
        ),
      )),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        waitingController.text = '0';
        extraChageController.text = '0';
        return alert;
      },
    );
  }

  showTripStartAlertDialog(BuildContext context) {
    final provider = context.read<TripProvider>();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Start Trip"),
      content: SizedBox(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure, you want to start the journey?'),
          vSpace18,
          MyButton(
            title: "Start Journey",
            onTap: () async {
              provider.startTrip();
              MyRouter.pop();
            },
          ),
        ],
      )),
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
