import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:society_manager/utils/ui_constants.dart';

class NetworkUtils{
  Future<String> submitOrderRazor(double finalAmount)async{
    try{
      final String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$razorPayId:$razorPaySecret'));
      final int price = (finalAmount*100).toInt();
      final response = await Client().post(Uri.parse("https://api.razorpay.com/v1/orders"),
          headers:
          {
            'Authorization':basicAuth,
            HttpHeaders.contentTypeHeader:'application/json'
          },
          body:
          json.encode(
              {
                "amount":price,
                "currency":"INR",
              }
          )
      );
      if(response.statusCode==200){
        final res = json.decode(response.body);
        return res['id'];
      }else{
        return 'failed';
      }
    }catch(e){
      return 'failed';
    }
  }
}