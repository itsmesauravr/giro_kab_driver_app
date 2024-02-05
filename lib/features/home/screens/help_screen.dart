import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Help')),
       body: ListView(

        children: [

          Image.asset('assets/img/help.jpg'),

          Card(
            child: ListTile(
              onTap: () {
                
              },
              leading: const Icon(Icons.phone, color: kcPrimary,),
              title: const Text('Call Us'),
                            trailing: const Icon(Icons.chevron_right, color: kcMediumGreyColor,),

            ),
          ),
          vSpace10,
           Card(
             child: ListTile(
              onTap: () {
                
              },
              leading: const Icon(Icons.mail, color: kcPrimary,),
              title: const Text('Mail Us'),
              trailing: const Icon(Icons.chevron_right, color: kcMediumGreyColor,),
                     ),
           )
        ],
       ),
     );
  }
}