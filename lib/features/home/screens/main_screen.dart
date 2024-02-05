import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/screens/account_screen.dart';
import 'package:giro_driver_app/features/home/providers/main_screen_provider.dart';
import 'package:giro_driver_app/features/home/screens/home_screen.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider =  context.read<MainScreenProvider>();
    const List<Widget> screens = [
      HomeScreen(),
   
      AccountScreen(),
      HomeScreen(),
   
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
        items:const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Account'),
      ]),
      
    ), selector: (p0, p1) => p1.currentIndex,);
  }
}