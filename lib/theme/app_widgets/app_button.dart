import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';

class MyButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final VoidCallback? onTap;
  final bool outline;
  final Widget? leading;

  const MyButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.busy = false,
    this.onTap,
    this.leading,
  })  : outline = false,
        super(key: key);

  const MyButton.outline({
    Key? key,
    required this.title,
    this.onTap,
    this.leading,
  })  : disabled = false,
        busy = false,
        outline = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
  
    
    Padding(
     padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(
          foregroundColor: kcTransparent , elevation: 0,  
          backgroundColor: outline?kcTransparent: !disabled ? kcPrimary : kcDisabled,
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(58.0),
        side:  BorderSide(color:outline? kcPrimary: kcTransparent )
        )
        ),
        onPressed: disabled?null:  onTap,
        child: SizedBox(
          height: 48, 
          child: Stack(
            children: [
              Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        child: !busy
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (leading != null) leading!,
                                  if (leading != null) hSpace5,
                                  Text(
                                    title,
                                    style: bodyStyle.copyWith(
                                      
                                      fontWeight:
                                          FontWeight.bold,
                                      color:disabled?kcMediumGreyColor : !outline ? kcBlack : kcPrimary,
                                    ),
                                  ),
                                  
                                ],
                              )
                            : const CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                      ),
                  //     const SizedBox(
                  //       height: 48, 
                  //       child: Align(
                  //         heightFactor: 1,  
                  //         alignment: Alignment.centerRight,
                  //         child:  Icon(
                  //   Icons.chevron_right,
                  //   color: kcFontPrimary,
                    
                  // ),),
                  //     )
            ],
          ),
        ), 
      ),
    );

   
  }
}
