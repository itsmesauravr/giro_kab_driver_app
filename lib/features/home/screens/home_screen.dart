import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giro_driver_app/features/account/screens/account_screen.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/features/earnings/screens/daywise_earnings_screen.dart';
import 'package:giro_driver_app/features/home/models/ads_model.dart';
import 'package:giro_driver_app/features/home/models/user_model.dart';
import 'package:giro_driver_app/features/home/providers/home_provider.dart';
import 'package:giro_driver_app/features/home/providers/main_screen_provider.dart';
import 'package:giro_driver_app/features/home/screens/change_password.dart';
import 'package:giro_driver_app/features/home/screens/help_screen.dart';
import 'package:giro_driver_app/features/home/screens/terms_and_conditions.dart';
import 'package:giro_driver_app/features/trips/provider/trip_provider.dart';
import 'package:giro_driver_app/theme/app_widgets/alow_expanded.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/extensions/string_extensions.dart';
import 'package:giro_driver_app/utils/geolocator/geolocator_helper.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider =  context.read<MainScreenProvider>();
    const List<Widget> screens = [
      
      EarningsScreen(),
      HomeScreen2(),
   
      AccountScreen()
    ];
    return Selector<MainScreenProvider,int>(builder: (context, value, child) =>  Scaffold(
      body: screens[value],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kcPrimary,
        unselectedItemColor: kcSecondary,  
        currentIndex: mainScreenProvider.currentIndex,
        onTap: (value) => mainScreenProvider.changeCurrentIndex(value),
        items: [
       BottomNavigationBarItem(
                  icon: mainScreenProvider.currentIndex == 0
                      ? Image.asset('assets/icons/earnings_active.png')
                      : Image.asset('assets/icons/earnings.png')
                  // Icon(Icons.car_repair_outlined)
                  ,
                  label: 'Rides'),
              BottomNavigationBarItem(
                  icon: mainScreenProvider.currentIndex == 1
                      ? Image.asset('assets/icons/home_active.png')
                      : Image.asset('assets/icons/home.png'),
                  label: 'Home'),
      const  BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Account'),
      ]),
      
    ), selector: (p0, p1) => p1.currentIndex,);
  }
}

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProfileDetailsUpdateProvider>();
    final homeProvider = context.read<HomeProvider>();
    Future.delayed(Duration.zero, () => homeProvider.getStatus());
    final tripProvider = context.read<TripProvider>();
    Future.delayed(
        Duration.zero, () => tripProvider.checkForCurrentActiveRide());

    final drawer2 = Drawer(
      width: 350,
      backgroundColor: kcSecondary,
      child: ListView(
        children: [
          vSpace18,
          FutureBuilder<UserProfile?>(
              future: homeProvider.showProfileDetails(),
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
                      final data = snapshot.data!;
                      return ListTile(
                        leading: CircleAvatar(
                              radius: 30,
                              foregroundImage: NetworkImage(
                                  '${AppStrings.siteUrl}/${data.photo}'),
                            ),
                            title: Text(
                              data.name.toTitleCase(),
                              style:
                                  heading2Style.copyWith(color: Colors.white),
                            ),
                            subtitle:Text(
                              data.driverId,
                              style:
                                  bodyStyleBold.copyWith(color: Colors.white),
                            )
                      );
                      
                    }

                    return const SizedBox();
                }
              }),
          ListTile(
            onTap: () => MyRouter.push(screen: const EarningsScreen()),
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Earnigs",
              style: drawerFontStyle,
            ),
          ),
          // ListTile(
          //   leading: Image.asset('assets/icons/drawerPlusIcons.png'),
          //   title: const Text(
          //     "Document Renewal",
          //     style: drawerFontStyle,
          //   ),
          // ),
          ListTile(
            onTap: () =>
                MyRouter.push(screen: const TermsAndConditionsScreen()),
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Terms and Conditions",
              style: drawerFontStyle,
            ),
          ),
          ListTile(
            onTap: () => MyRouter.push(screen: const HelpScreen()),
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Help",
              style: drawerFontStyle,
            ),
          ),
          ExpansionTile(
            collapsedIconColor: kcLight,
            leading: Image.asset('assets/icons/drawerPlusIcons.png'),
            title: const Text(
              "Settings",
              style: drawerFontStyle,
            ),
            children: [
              ListTile(
                onTap: () =>
                    MyRouter.push(screen: const ChangePasswordScreen()),
                leading: hSpace25,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: kcLight,
                ),
                title: const Text(
                  "Change Password",
                  style: drawerFontStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  showAlertDialog(context, provider.logoutDriver);
                },
                leading: hSpace25,
                trailing: const Icon(
                  Icons.logout,
                  color: kcDanger,
                ),
                title: const Text(
                  "Logout",
                  style: drawerFontStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    final appBar2 = AppBar(
      leading: IconButton(
        icon: 
        const Icon(Icons.sort, size: 32,),
        // Image.asset('assets/icons/menuIcon.png'),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
       

        Selector<HomeProvider, bool>(
            selector: (p0, p1) => p1.isLoading,
            builder: (context, value, _) {
              return
              value?const SizedBox(
                width: 70,
                height: 10,
                child:  Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(),
                )):
               Switch(
                value: homeProvider.isActive,
                onChanged: homeProvider.changeStatus,
              );
            }), 
            hSpace10,
        IconButton(
          icon: Image.asset('assets/icons/wallet_icon_filled.png'),
          onPressed: () => MyRouter.push(screen: const EarningsScreen()),
        ),
        hSpace10,
        // IconButton(
        //   icon: Image.asset('assets/icons/notification.png'),
        //   onPressed: () {},
        // ),
        // hSpace10,
      ],
    );
    final adBuilder = FutureBuilder<Ads>(
        future: homeProvider.displayAds(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // indicating that the async operation has begun
            case ConnectionState.waiting:
              return const SizedBox();
            // When async operation is completed.
            case ConnectionState.done:
            default:
              //if snapshot has data
              if (snapshot.hasData) {
                final adsPage = snapshot.data!.adsDetails
                    .map(
                      (e) => SizedBox(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              "http://girokab.com/${e.photo}",
                              fit: BoxFit.cover,
                            )),
                      ),
                    )
                    .toList();
                return adsPage.isNotEmpty
                    ? CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          aspectRatio: 16/9,
                          enlargeCenterPage: true,
                        ),
                        items: adsPage,
                      )
                    : const SizedBox();
              }
              //if snapshot has error
              if (snapshot.hasError) {
                return const SizedBox();
              }
              //if snapshot is null
              return const SizedBox();
          }
        });
    final map = Expanded(
      child: FutureBuilder<Position>(
          future: getUserPosition(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final lat = snapshot.data?.latitude;
              final lng = snapshot.data?.longitude;

              LatLng pos = const LatLng(13.018715, 80.261715);
              if (lat != null && lng != null) {
                pos = LatLng(lat, lng);
              }
              return Container(
                decoration: const BoxDecoration(color: kcPrimary),
                child: GoogleMap(
                  circles: {
                    Circle(
                        center: pos,
                        radius: 20,
                        circleId: const CircleId('value'))
                  },
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    // tilt: 90,
                    target: pos,
                    zoom: 13.5,
                  ),
                ),
              );
            }
            return const Text('loading');
          }),
    );
    final earningsBuilder = FutureBuilder<Map<String, dynamic>>(
        future: homeProvider.getTodaysEarning(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
            default:
              if (snapshot.hasData) {
                int earnings = 0;
                try {
                final a = snapshot.data!['earnings'] as num;
                earnings = a.toInt();
                  
                } catch (_) {
                }
                return Row(
                  children: [
                    Expanded(
                        child: EarningsBox(
                      title: 'Earnings',
                      img: 'assets/icons/earningsSack.png',
                      value: '₹ $earnings',
                    )),
                    Expanded(
                        child: EarningsBox(
                      title: 'Rides',
                      img: 'assets/icons/ridesCar.png',
                      value:
                          snapshot.data!['completed_rides']?.toString() ?? '0',
                    ))
                  ],
                );
              }
              //if snapshot has error
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              //if snapshot is null
              return const Center(child: Text('No data found'));
          }
        });
    return Scaffold(
        key: _scaffoldKey,
        drawer: drawer2,
        appBar: appBar2,
        body: AllowExpanded(
          colomn: Column(
            children: [
              vSpace10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: adBuilder,
              ),
              // AspectRatio(
              //   aspectRatio: 414 / 171,
              //   child: Container(
              //     padding: const EdgeInsets.all(10),
              //     decoration: const BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [Color(0xffffb300), Color(0xffffdf95)],
              //       ),
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children:const [
              //                Text('Why Wait?', style: headlineStyle,),
              //                Text('Use Giro Kab', style: heading3Style,)
              //             ],
              //           ),
              //         ),
              //         Image.asset('assets/img/login-img.png',height: 100,)
              //       ],
              //     ),
              //   ),
              // ),
              // vSpace5,
              // Image.asset('assets/img/ad.png'),
              vSpace18,
              earningsBuilder,
              vSpace18,
              map,
              
            ],
          ),
        ));
  }

  showAlertDialog(
    BuildContext context,
    VoidCallback logout,
  ) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Logout"),
      onPressed: () async {
        logout();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        MyRouter.pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [okButton, cancelButton],
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

class EarningsBox extends StatelessWidget {
  const EarningsBox({
    super.key,
    required this.img,
    required this.title,
    required this.value,
  });
  final String img;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromARGB(255, 238, 238, 237),
      ),
      child: Row(
        children: [
          Image.asset(
            img,
            height: 45,
            width: 45,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  value,
                  style: heading2Style.copyWith(
                    fontSize: 20,
                    color: kcPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(title)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<Position> getUserPosition() async {
  try {
    final position = await GeoLocationService.determinePosition();
    final dio = await InterceptorHelper.getApiClient();
    dio.post('driver-location-updates', data: {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
    return position;
  } catch (e) {
    e;
    rethrow;
  }
}
