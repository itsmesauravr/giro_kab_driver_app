
import 'package:giro_driver_app/utils/extensions/string_extensions.dart';

class FormValidator {

  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Please fill this field'; 
    return null;
  }
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    if(!value.isName) return 'Please enter a valid name';
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your mobile number';
    if (value.length!=10) return 'Mobile number mustbe 10 digits';

    return null;
  }

    static String? validatePincode(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your pincode';
    if (value.length!=6) return 'Pincode mustbe 6 digits';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if(!value.isBetween(6, 12)) return 'Password must be 6 - 12 characters';
    return null;
  }

  static String? validateConfirmPassword(String? value, String text) {
    if (value == null || value.isEmpty) return 'Pleas enter a password';
    if (value != text) {
      return 'Password does not match';
    }
    return null;
  }
  static  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter your email';
    if(!value.isEmail) return 'Please enter a valid email';
    return null;
  }
}
