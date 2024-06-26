import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Dio dio = Dio();



Future<void> loginModel(String email, String password) async {
  final storage =   FlutterSecureStorage();

  try {
    Response response = await dio.post(
      'http://here:3000/login',
      data: {
        'email': email,
        'password':password},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

      FlutterSecureStorage.setMockInitialValues({});

  var token= response.data['token'];
  await storage.write(key: 'token', value: token);

  print(response.data);
  print(response.data['token']);
  print("Token: $token");
  storage.read(key: 'token').then((token) {
      print(token);
    });
  
    // List<String>? tokenParts = token?.split('.');
    // String header = tokenParts![0];
    // String payload = tokenParts[1];
    // String signature = tokenParts[2];
    //
    // String decodedPayload = utf8.decode(base64Url.decode(payload));
    // Map<String, dynamic> payloadMap = json.decode(decodedPayload);
    // print("Header: $header");
    // print("Decoded Payload: $decodedPayload");
    // print("Signature: $signature");
    // print("Payload Map: $payloadMap");

  }


  on DioError catch(e)
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

