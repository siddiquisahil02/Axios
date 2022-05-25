import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/main.dart';
import 'package:society_manager/utils/ui_constants.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.data}) : super(key: key);
  final Map<String,dynamic> data;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  late final Map<String,dynamic> options;

  final _razorPay = Razorpay();
  int status = 0;

  @override
  void initState() {
    super.initState();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    options = {
      'key': razorPayId,
      'amount': widget.data['totalAmount'],
      'name': 'Axios',
      'currency': 'INR',
      'order_id': widget.data['orderID'],
      'description': 'Payment for Rs.${widget.data['totalAmount']}/-',
      'prefill': {
        'name': widget.data['name'],
        'email':widget.data['email']
      }
    };
    _razorPay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async{
    Fluttertoast.showToast(msg: "Payment Successful");

    await firebase
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('payments')
        .add(
      {
        "paymentID":response.paymentId,
        "orderID":response.orderId,
        "signature":response.signature,
        "createdAt":Timestamp.now(),
        "amount":(widget.data['totalAmount']/100)
      }
    );

    await firebase
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update(
        {
          'dues':0
        }
    );

    setState(() {
      status = 1;
    });
    flutterLocalNotificationsPlugin.show(
        1,
        "Payment Done",
        "Payment for Rs. ${widget.data['totalAmount']/100} is completed successfully.",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription:channel.description,
            playSound: true,
            icon: "@mipmap/ic_launcher",
          ),
        ));
    Timer(const Duration(seconds: 2),(){
      Navigator.pushNamedAndRemoveUntil(context,'/',(route) => false);
    });
    //Navigator.pushNamedAndRemoveUntil(context,'/', (route) => false);
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed : ${response.message}");
    log(response.code.toString());
    setState(() {
      status = 3;
    });
    Timer(const Duration(seconds: 2),(){
      Navigator.pushNamedAndRemoveUntil(context,'/',(route) => false);
    });
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response)async{
    Fluttertoast.showToast(msg: "Payment Successful using external wallet");
    log(response.walletName.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: showStatus(status)
      ),
    );
  }

  Widget showStatus(int status){
    switch(status){
      case 0:
        return const CircularProgressIndicator();
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Taking you to Home Page",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 15),
            const Text("Please Wait 2 Sec. !")
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Payment Failed",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 15),
            const Text("Please Wait 3 Sec. !")
          ],
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorPay.clear();
  }
}
