import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Screens/register.dart';
import 'package:graduation_project/components/button.dart';
import 'package:graduation_project/layout/home_layout.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/TextFormField.dart';
import '../helpers/snackbar.dart';
import '../models/login_model.dart';

class login extends StatefulWidget {

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool isPassword = true;

  String errorMessage = '';

final emailController= TextEditingController();
final passwordController= TextEditingController();

  var email, password,token, message, userName;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  RegExp regPass =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  RegExp regEmail =
  RegExp(r'^(?=.*?[a-z])(?=.*?[!@#\$&*~])(?=.*[.]).{8,}$');


  bool isLoading = false;


  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: globalFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3.6,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.green.withOpacity(0.2),
                              Colors.greenAccent
                            ]
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/logo.png",
                              width: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login",
                    style: GoogleFonts.robotoCondensed(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 45,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  defaultTextForm(
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'Please enter Email';
                        } else {
                          if (!regEmail.hasMatch(data)) {
                            return 'Enter valid Email';
                          } else {
                            return null;
                          }
                        }
                      },
                      onChanged: (data) {
                        email = data;
                      },
                      pref: const Icon(
                        Icons.email_rounded,
                        color: Colors.black,
                      ),
                      labelText: "Email",
                      hintText: "Enter your e-mail"),


                  defaultTextForm(
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'Please enter password';
                        } else {
                          if (!regPass.hasMatch(data)) {
                            return 'Enter valid password';
                          } else {
                            return null;
                          }
                        }
                      },
                      type: TextInputType.visiblePassword,
                      onChanged: (data) {
                        password = data;
                      },
                      pref: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      suffix: isPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      isPassword: isPassword,
                      suffixPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      labelText: "Password",
                      hintText: "Enter your Password"),

                  const SizedBox(
                    height: 10,
                  ),

                  CustomButton(
                    size: 25,
                    text: "Login",
                    onTap: () async {
                      if (globalFormKey.currentState!.validate()) {
                        try {

                          setState(() {
                            isLoading=true;
                          });
                          await loginModel(email, password);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLayout(currentIndex: 0,)));
                          showSnackBar(context, "Login Successfully");
                        } on DioError catch (e) {
                          if (e.response != null) {
                            String message = e.response?.data['message'];
                            message = message.replaceAll(
                                'Incorrect password', 'Wrong Password');
                            message = message.replaceAll(
                                '"email" must be a valid email',
                                'Invalid Email');
                            showSnackBar(context, message.toString());
                          } else if (e.error is TimeoutException) {
                            showSnackBar(context, "Connection timeout error");
                          }
                          else if (e.error is SocketException) {
                            showSnackBar(context, "Network connection error");
                          } else {
                            showSnackBar(context,
                                "An error occurred: ${e.message}");
                          }

                          setState(()
                          {
                            isLoading=false;
                          });

                          rethrow;
                        }

                              setState(()
                              {
                                isLoading = false;
                              });

                      }
                    },
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "don't have an account ? ",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Signup()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  )

                ],


              ),

            ),
          ),


    ),
      );
  }
}



