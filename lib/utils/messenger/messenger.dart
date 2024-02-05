
import 'package:flutter/material.dart';

class Messenger {
  static final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static alert({required String msg, Color? color}) {
    // Size size =
    
    //     MediaQuery.of(rootScaffoldMessengerKey.currentState!.context).size;
    
    rootScaffoldMessengerKey.currentState?.
    showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        duration: const Duration(milliseconds: 3000), 
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        // margin: EdgeInsets.only(bottom: size.height - 110, right: 20, left: 20), 
        content: Text(
          msg, 
          style: const TextStyle(
            fontWeight: FontWeight.w500,  
            fontSize: 12,
          ), 
        ),
      ),
       
    ); 
  }

  static pop(BuildContext context){
    // print('heelelelreo');
    // final context = rootScaffoldMessengerKey.currentState?.context;
    //   print('heeesdfkdhakajfkdkfhasdkfldfhdsfsdf');

    // if (context == null) {
    //   print('hello');
    //   return;
    // } 
  showModalBottomSheet<void>(
    constraints: const BoxConstraints.expand() ,
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.blue[100],
                child: ListView.builder(
                  // controller: scrollController,
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(title: Text('Item $index'));
                  },
                ),
            );
          },
              ); 
              
              // Container(
              //   height: 200,
              //   color: Colors.amber,
              //   child: Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       mainAxisSize: MainAxisSize.min,
              //       children: <Widget>[
              //         const Text('Modal BottomSheet'),
              //         ElevatedButton(
              //           child: const Text('Close BottomSheet'),
              //           onPressed: () => Navigator.pop(context),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
           
      }
}