import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:graduation_project/Screens/Profile.dart';
import 'package:graduation_project/Screens/login.dart';
import 'package:graduation_project/layout/home_layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'Screens/register.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create:(context)=>UserProvider(),
    ),
  ],
      child: const MyApp()));
}
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      backgroundColor: Colors.white,
      splash: Lottie.asset(
        "assets/Splash.json",
        repeat: true,
      ),
      splashIconSize: 300,
      nextScreen: login(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      routes: {
        "LoginPage":(context)=>login(),
        "SignUp":(context)=>Signup(),
        "Profile":(context)=>const Profile(),
        "HomeLayout":(context)=>const HomeLayout(currentIndex: 1,),

      },
      debugShowCheckedModeBanner: false,
     home: SplashScreen(),

    );
  }
}

