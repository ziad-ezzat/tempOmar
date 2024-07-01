import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/helpers/showdialog.dart';
import 'package:graduation_project/components/button.dart';
import 'package:graduation_project/models/signup_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/TextFormField.dart';
import '../helpers/snackbar.dart';

class Signup extends StatefulWidget {

  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _signupState();
}

class _signupState extends State<Signup> {

  bool isPassword = true;
  final emailController= TextEditingController();
  final passwordController= TextEditingController();

  var email, password,confirmPassword,userName,message,durationInSeconds;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  RegExp regPass =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  RegExp regEmail =
  RegExp(r'^(?=.*?[a-z])(?=.*?[!@#\$&*~])(?=.*[.]).{8,}$');


  bool isLoading = false;


  bool isApiCallProcess = false;


  @override
  Widget build(BuildContext context) {
    return  ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          backgroundColor:Colors.white ,
          body: Form(
            key: globalFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5.8,
                    decoration:BoxDecoration(
                        gradient:LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.green.withOpacity(0.2),
                              Colors.greenAccent
                            ]
                        ),
                        borderRadius:const BorderRadius.only(
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
                              width: 250,
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
                  Text(
                    "Signup",
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
                    validator:(value) {
                      if (value!.isEmpty) {
                        return 'Username is required';
                      }
                      if (value.length < 4) {
                        return 'Username must be at least 4 characters long';
                      }
                      if (value.length > 20) {
                        return 'Username must be less than 20 characters long';
                      }
                      return null;
                    },
                    onChanged: (data)
                    {
                     userName =data;
                    },
                      pref: const Icon(Icons.account_circle_rounded,color: Colors.black,),
                      labelText: 'Username',
                      hintText: "Enter your name",

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
                      onChanged: (data)
                      {
                        email=data;
                      },
                      pref: const Icon(
                        Icons.email_rounded,
                        color: Colors.black,
                      ),
                      labelText: "Email",
                      hintText: "Enter your e-mail"
                  ),



                  defaultTextForm(
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'Please enter password';
                        } else {
                          if (!regPass.hasMatch(data)) {
                            return 'At Least 12334 or @#% or Alphabetic character';
                          } else {
                            return null;
                          }
                        }
                      },
                      type: TextInputType.visiblePassword,
                      onChanged: (data)
                      {
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

                defaultTextForm(
                      validator: (data) {
                        if (data!=password) {
                          return 'Please enter the password again';
                        }
                        },
                      type: TextInputType.visiblePassword,
                      onChanged: (data)
                      {
                        confirmPassword = data;
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
                      labelText: "Confirm Password",
                      hintText: "Confirm Your Password"),


                  const SizedBox(
                    height: 10,
                  ),

                  CustomButton(
                    size: 25,
                      text: "Signup",
                      onTap: ()async{
                          if (globalFormKey.currentState!.validate()) {
                            isLoading=true;
                            setState(() {});
                            try {
                              await signupModel(userName, email, password, confirmPassword);

                              Navigator.pushNamed(context, "LoginPage");

                              show(context, title: 'Thanks $userName for Signup! \n \n Please check your email to verify it \n');
                            }  on DioError catch(e) {

                              if(e.response!=null){
                                String message = e.response?.data['message'];
                                if (message != null) {
                                  message=message.replaceAll('User already exists', 'The Email already exist !');
                                  showSnackBar(context, message.toString());
                                }else if (e.error is TimeoutException) {
                                  showSnackBar(context, "Connection timeout error");
                                }
                                else if (e.error is SocketException) {
                                  showSnackBar(context, "Network connection error");
                                }
                              } else {
                                message = 'An error occurred';
                                showSnackBar(context, message);
                              }
                              isLoading=false;
                              setState(() {});

                              rethrow;

                            }
                                    isLoading = false;
                                    setState(() {});
                                    } else {}

                      }
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "already have an account?  ",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      ),
                     const SizedBox(
                        height: 50,
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

