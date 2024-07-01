import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:graduation_project/models/userModel.dart';
import 'package:provider/provider.dart';

Dio dio = Dio();

Future<void> loginModel(
    BuildContext context, String email, String password) async {
  final storage = FlutterSecureStorage();

  try {
    Response response = await dio.post(
      'http://192.168.1.20:3000/login',
      data: {'email': email, 'password': password},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    var token = response.data['token'];
    await storage.write(key: 'token', value: token);

    var userName = getName(response.data['message']);

    User user = User(
      id: '',
      userName: userName,
      email: email,
      createdAt: DateTime.parse(DateTime.now().toString()),
      role: 'user',
      orderHistory: [],
      searchHistory: [],
    );

    Provider.of<UserProvider>(context, listen: false).saveUserProfile(user);

    print(response.data);
    print(response.data['token']);
    print("Token: $token");
    storage.read(key: 'token').then((token) {
      print(token);
    });
  } on DioError catch (e) {
    if (e.response != null) {
      print(e.response!.data.toString());
    } else if (e.error is SocketException) {
      print(e.message.toString());
    } else if (e.error is TimeoutException) {
      print(e.message.toString());
    } else {
      print(e.message.toString());
    }
    rethrow;
  }
}

String getName(String name) {
  return name.substring(6);
}
