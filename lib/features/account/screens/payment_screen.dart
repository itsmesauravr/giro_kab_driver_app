import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/app_widgets/app_texts.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'payment_web_view_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final povider = context.read<PaymentProvider>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const BodyText.bold("Payment"),
          ),
          body: FutureBuilder<String>(
              future: povider.getRegistrationFee(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // indicating that the async operation has begun
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  // When async operation is completed.
                  case ConnectionState.done:
                  default:
                    //if snapshot has data
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const Text(
                            "Pay the amount to complete registration",
                            style: TextStyle(
                              color: Color(0xff565656),
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: kcPrimary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "₹ ${snapshot.data}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 46,
                                  fontFamily: "DM Sans",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MyButton(
                              title: "Continue",
                              onTap: () async {
                                MyRouter.push(screen: const PaymentWebView());

                                // await povider.makePayment();
                              },
                            ),
                          )
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
              }),
        ),
        Selector<PaymentProvider, bool>(
          selector: (_, provider) => provider.isBusy,
          builder: (_, isLoading, __) {
            return isLoading
                ? const Opacity(
                    opacity: 0.7,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  )
                : const SizedBox();
          },
        ),
        Selector<PaymentProvider, bool>(
          selector: (_, provider) => provider.isBusy,
          builder: (_, isLoading, __) {
            return isLoading
                ? Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          BodyText(
                            'Please wait... ',
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}

class PaymentProvider extends ChangeNotifier {
  bool isBusy = false;

  String amount = '-1';

  // final _razorpay = Razorpay();

  Future<String> getRegistrationFee() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get('driver-registration-fee');
      if (res.statusCode == 200) {
        log(res.data.toString());
        amount = res.data['registration_fee'];
        return amount;
      }
      throw '';
    } catch (e) {
      e;
      rethrow;
    } finally {
    }
  }

  // Future<void> makePayment() async {
  //   try {
  //     isBusy = true;
  //     notifyListeners();
  //     createOrder(
  //         bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
  //         amount: double.parse(amount),
  //         phoneNumber: '');
  //   } catch (e) {
  //     Messenger.alert(msg: 'Something went wrong', color: kcDanger);
  //     e;
  //   } finally {
  //     isBusy = false;
  //     notifyListeners();
  //     print('completed');
  //   }
  // }

  // create order
  // void createOrder({
  //   required String bookingId,
  //   required double amount,
  //   required String phoneNumber,
  // }) async {
  //   String username = _Cred.keyId;
  //   String password = _Cred.keySecret;
  //   String basicAuth =
  //       'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  //   Map<String, dynamic> body = {
  //     "amount": amount * 100,
  //     "currency": "INR",
  //     "receipt": bookingId
  //   };
  //   final headers = <String, String>{
  //     "Content-Type": "application/json",
  //     'authorization': basicAuth,
  //   };
  //   var res = await Dio().post(
  //     "https://api.razorpay.com/v1/orders",
  //     options: Options(headers: headers),
  //     data: jsonEncode(body),
  //   );

  //   if (res.statusCode == 200) {
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  //     _openGateway(
  //       orderId: res.data['id'],
  //       amount: amount,
  //       phoneNumber: phoneNumber,
  //     );
  //   }
  //   log(res.data.toString());
  // }

  // _openGateway(
  //     {required String orderId,
  //     required double amount,
  //     required String phoneNumber}) {
  //   var options = {
  //     'key': _Cred.keyId,
  //     'amount': amount * 100, //in the smallest currency sub-unit.
  //     'name': 'GiroKab',
  //     'order_id': orderId, // Generate order_id using Orders API
  //     'description': 'Registration Fee',
  //     'timeout': 60 * 5, // in seconds // 5 minutes
  //     'prefill': {
  //       'contact': '9123456789',
  //       'email': 'info@girokab.com',
  //     }
  //   };
  //   _razorpay.open(options);
  // }

  // _verifySignature({
  //   String? signature,
  //   String? paymentId,
  //   String? orderId,
  // }) async {
  //   Map<String, dynamic> body = {
  //     'razorpay_signature': signature,
  //     'razorpay_payment_id': paymentId,
  //     'razorpay_order_id': orderId,
  //   };

  //   var parts = [];
  //   body.forEach((key, value) {
  //     parts.add('${Uri.encodeQueryComponent(key)}='
  //         '${Uri.encodeQueryComponent(value)}');
  //   });
  //   var formData = parts.join('&');
  //   final headers = {
  //     "Content-Type": "application/x-www-form-urlencoded", // urlencoded
  //   };

  //   var res = await Dio().post(
  //     // Uri.https(
  //     //   "10.0.2.2", // my ip address , localhost
  //     //   "razorpay_signature_verify.php",
  //     // ),
  //     'urlForServersideVerification',
  //     options: Options(headers: headers),
  //     data: formData,
  //   );

  //   log(res.data.toString());
  //   if (res.statusCode == 200) {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text(res.body),
  //     //   ),
  //     // );
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   // Do something when payment succeeds
  //   log('======Succcess==========');

  //   log(response.paymentId.toString());

  //   log('======Succcess==========');
  //   var date = DateTime.now();
  //   final dataString = "${date.toLocal()}".split(' ')[0];

  //   final dio = await InterceptorHelper.getApiClient();
  //   final res = await dio.post('driver-fee-payment', data: {
  //     'amount': amount,
  //     'payment_date': dataString,
  //     'reference_id': response.paymentId.toString()
  //   });
  //   if (res.statusCode == 200) {
  //     _razorpay.clear();
  //     Messenger.alert(msg: 'Payment successfull', color: kcSuccess);
  //     MyRouter.pushRemoveUntil(screen: const PersonalDetailsUpdateScreen());

  //     log(res.data.toString());
  //     return;
  //   }

  //   try {
  //     Messenger.alert(msg: 'Payment Successfull', color: kcSuccess);
  //   } catch (_) {}
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   log('======Failed==========');
  //   log(response.toString());
  //   log('======Failed==========');

  //   Messenger.alert(msg: 'Payment Failed', color: kcDanger);
  //   _razorpay.clear();
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   log('======Walet==========');
  //   log(response.toString());
  //   log('======Walet==========');
  //   _razorpay.clear();
  // }
}

// class _Cred {
//   static get keyId => 'rzp_test_6hEAaOcbEZqjVl';
//   static get keySecret => "Z4OKEhSKVlBPWhSQHtqAcaZQ";
// }
