

import 'package:giro_driver_app/features/account/screens/account_screen.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_form_screen.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/features/auth/screens/auth_screen.dart';
import 'package:giro_driver_app/features/auth/screens/forgot_password_screen.dart';
import 'package:giro_driver_app/features/auth/screens/login_screen.dart';
import 'package:giro_driver_app/features/auth/screens/login_with_mobile_screen.dart';
import 'package:giro_driver_app/features/auth/screens/onboarding_screen.dart';
import 'package:giro_driver_app/features/auth/screens/signup_screen.dart';
import 'package:giro_driver_app/features/auth/screens/splash_screen.dart';

class MyRoutes {
  static final routes= {  
    init: (context) => const SplashScreen(),
    onBoarding: (context) =>const OnboardingScreen(),

    auth: (context) =>const AuthScreen(),
    login: (context) =>const LoginScreen(),
    loginWithMobile: (context) =>const LoginWithMobileScreen(), 
    signup: (context) =>const SignupScreen(),
    forgotPassword: (context) =>const ForgotPasswordScreen(),

   

    account: (context) =>const AccountScreen(), 
    updatePersonalDetails: (context) =>const PersonalDetailsUpdateScreen(),
    personalDetailsForm: (context) =>const PersonalDetailsFormScreen(),
    
    // home: (context) =>const HomeScreen(),
    // scratchCoupon: (context) => const ScratchCouponScreen(),
    // viewAllPackages: (context) =>const ViewAllPackagesScreen(), 
    // packageDetails: (context) =>const PackageDetailsPage(), 
    // viewAllProducts: (context) =>const ViewAllProductsScreen(), 
    // productDetails: (context) =>const ProductDetailsPage(),  
    // redeemHistory: (context) =>const RedeemHistoryScreen(), 
    // rewardsHistory: (context) =>const RewardssHistoryScreen(),  
    // addPincode: (context) =>const AddPincodeScreen(),  
    // editProfile: (context) =>const EditProfileScreen(),  
    // changePassword: (context) =>const ChangePasswordScreen(),      
  };
  
  static const init = '/';
  static const onBoarding = 'onBoardingScreen';
  static const auth = 'authScreen';
  static const main = 'mainScreen';
  static const login = 'loginScreen';
  static const loginWithMobile = 'loginWithMobileScreen';
  static const forgotPassword = 'forgotPasswordScreen';
  static const signup = 'signupScreen';

  // static const home = 'homeScreen';  
  static const account = 'accountScreen'; 
  static const updatePersonalDetails = 'updatePersonalDetails'; 
  static const personalDetailsForm = 'personalDetailsForm'; 


}