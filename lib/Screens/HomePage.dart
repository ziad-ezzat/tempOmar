import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Providers/UserProvider.dart';
import '../layout/home_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
List<Map<String, dynamic>> dataList = [
  {
    'imageURL': 'assets/Login_cover.jpg',
    'description': 'Sign in - Sign up and the ability to change your username in profile page and show your Search history - Order history',
    "Number":"1"
  },
  {
    'imageURL': 'assets/medicines-l.jpg',
    'description': 'Make search for all types of medical items in pharmacies and know the similar item by its Active Ingredient.',
    "Number":"2"
  },
  {
    'imageURL': 'assets/add-to-cart.png',
    'description': 'Add the medical items to your cart and can delete any item of it, Checkout with the total price and select the payment method.',
    "Number":"3"
  },
  {
    'imageURL': 'assets/scan (1).png',
    'description': 'Scan the prescription from gallery or main camera  ',
    "Number":"4"
  },

];


class _HomePageState extends State<HomePage> {
  late Future<void> _dataLoading;

  @override
  void initState() {
    super.initState();
    _dataLoading = Provider.of<UserProvider>(context, listen: false).loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context);
    final user = userInfo.user;

    return FutureBuilder<void>(
      future: _dataLoading,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child:Lottie.asset(
              'assets/Loading.json',
              height: 300,
              width: 300,
            ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error loading data',
                style: GoogleFonts.righteous(
                  color: Colors.green,
                  fontSize: 35,
                  fontWeight: FontWeight.w900
              ),),
            ),
          );
        } else {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          height: 90,
                          width: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Hello, ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: user?.userName ?? "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w900,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeLayout(currentIndex: 2)),
                            );
                          },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLayout(currentIndex: 1)));
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xffe4faf0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(Icons.search,color: Colors.grey,),
                              SizedBox(width: 20,),
                              Text(
                                  "Search For Medicine!",
                                style: GoogleFonts.righteous(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: "Scan Prescription\nand Find Medicines\nWith MEDMATCH",
                    //         style: GoogleFonts.aldrich(
                    //           fontSize: 12,
                    //           color: Colors.green,
                    //           fontWeight: FontWeight.w900,
                    //           height: 1.5, // Adjust the line spacing as needed
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    SizedBox(height: 25,),

                    Text(
                      "Features",
                      style: GoogleFonts.righteous(
                          color: Colors.green,
                          fontSize: 30,
                          fontWeight: FontWeight.w900
                      ),
                    ),

                    SizedBox(height: 25,),

                    Expanded(
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.resolveWith<Color>(
                                (states) => Colors.green.shade300,
                          ),
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 7,
                          radius: const Radius.circular(5),
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              String? description = dataList[index]['description'];
                              String? imageURL = dataList[index]['imageURL'];
                              String? number = dataList[index]['Number'];
                              return Container(
                                margin: EdgeInsets.all(20),
                                height: 200,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          imageURL!,
                                          height: 200,
                                          width: 400,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green.shade300,
                                            ),
                                            child: Center(
                                              child: Text(
                                                number.toString(),
                                                style: GoogleFonts.nanumBrushScript(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          description!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            },
                            separatorBuilder: (context, index) => SizedBox(height: 20),
                            itemCount: dataList.length,
                          ),
                        ),
                      ),
                    )



                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
