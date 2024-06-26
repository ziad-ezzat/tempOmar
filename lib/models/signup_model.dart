import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();
Future<void> signupModel(String userName, String email, String password, String confirmPassword) async {
  try {
    
    Response response = await dio.post(
      'http://here:300/signup',
      data: {'userName': userName, 'email': email, 'password':password, 'confirmPassword':confirmPassword},
    );
    print(response.data);
  } on DioError catch(e)
  {

    if(e.response!=null)
    {
      print(e.response!.data.toString());
    }
    else if (e.error is SocketException) {
      print(e.message.toString());
    }else if (e.error is TimeoutException) {
      print(e.message.toString());
    }
    else
    {
      print(e.message.toString());
    }
    rethrow;

  }
}