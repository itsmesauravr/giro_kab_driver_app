import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';

class InputField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final bool disabled;
  final void Function()? trailingTapped;
  void Function(String)? onValueChanged;
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );
  
  //dropdown field properties
  final bool isDropdown;
  final Object? intialValue;
  final void Function(dynamic)?  onChanged;
  final List<DropdownMenuItem<Object?>>? items;
  final String? Function(Object?)? dropDownValidator;
  // final T type;


  InputField({
    Key? key,
    this.validator,
    this.inputAction,
    this.inputType,
    this.hintText,
    this.controller,
    this.labelText, 
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.password = false,
    this.disabled = false,
    this.onValueChanged,
  }) :
  dropDownValidator=null, 
  items =null,
  onChanged =null,
  intialValue= null,
    isDropdown= false,
   super(key: key);


  InputField.dropdown({
    Key? key,
    this.dropDownValidator,
    this.inputAction,
    this.inputType,
    this.hintText,
    this.controller,
    this.labelText, 
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.disabled = false,

    this.intialValue,
    required this.onChanged,
    required this.items,
  }): validator= null, password = false,isDropdown = true,super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: isDropdown?

      DropdownButtonFormField<dynamic>(
        
        validator: dropDownValidator,
        key: key,
        value: intialValue,
        items: items,
        onChanged: onChanged,
        decoration: myInputDecoration(),
      ):
      
      TextFormField(
        onChanged: onValueChanged,
        enabled: !disabled,
        keyboardType: inputType,
        controller: controller,
        style: const TextStyle(height: 1, color:  kcFontPrimary), 
        obscureText: password,
        validator: validator,
        decoration: myInputDecoration(),
      ),
    );
  }

  InputDecoration myInputDecoration() {
    return InputDecoration(     
        labelText: labelText,
        labelStyle: const TextStyle(color: kcFontPrimary),  
        hintText: hintText,
        hintStyle: const TextStyle(height: 1, color:  kcFontPrimary ) ,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        filled: true,
        fillColor: kcVeryLightGrey, 
        prefixIcon: leading,
        suffixIcon: trailing != null
            ? GestureDetector(
                onTap: trailingTapped,
                child: trailing,
              )
            : null,
        border: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcLight),
        ),
        errorBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcLightGreyColor),
        ),
        focusedBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcLightGreyColor), 
        ),
        enabledBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcLightGreyColor),
        ),
      );
  }
}


