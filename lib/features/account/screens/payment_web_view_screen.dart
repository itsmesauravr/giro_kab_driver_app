import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/account/screens/personal_details_update_screen.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/secure_storage/secured_storage_services.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({Key? key, }) : super(key: key);

  
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
   WebViewController? controller;

  @override
  void initState() {
    final storage = SecuredStorage.instance;
    storage.read('accessToken').then((value) {
      final header = {
        "Authorization": "Bearer $value",
        'Accept': 'application/json'
      };
      log('Header ===== $header');
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(
            Uri.parse(
                'https://girokab.com/api/online-regfee'),
            headers: header);
            setState(() {
              
            });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title:const Text('Giro Kab'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () =>    MyRouter.pushRemoveUntil(screen: const PersonalDetailsUpdateScreen()),
          ),
        ),
        body:controller==null? const CircularProgressIndicator(): WebViewWidget(controller: controller!),
      ),
    );
  }
}
