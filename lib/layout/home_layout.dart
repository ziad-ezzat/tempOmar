import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduation_project/Screens/cart.dart';
import 'package:graduation_project/Screens/orders.dart';
import 'package:provider/provider.dart';

import '../Providers/UserProvider.dart';
import '../Screens/HomePage.dart';
import '../Screens/Profile.dart';
import '../Screens/Scan.dart';
import '../Screens/Search.dart';

class HomeLayout extends StatefulWidget {
  final int currentIndex;

  const HomeLayout({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late int currentIndex;
  late List<Widget> screens;

  @override
  void initState() {
    currentIndex = widget.currentIndex;
    screens =  [
      HomePage(),
      Search(),
      Cart(),
      Scan(),
      Orders(),
      Profile(),
    ];
    super.initState();
    saveToken();
  }

  void saveToken() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConditionalBuilder(
        condition: screens.isNotEmpty,
        builder: (context) => screens[currentIndex],
        fallback: (BuildContext context) => const Text('Error'),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GNav(
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.green.withOpacity(0.8),
            gap: 20,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.shopping_cart, text: 'Cart'),
              GButton(icon: Icons.camera_alt, text: 'Scan'),
              GButton(icon: Icons.account_balance_wallet, text: 'Orders'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
            selectedIndex: currentIndex,
            onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });

            },
          ),
        ),
      ),
    );
  }
}


