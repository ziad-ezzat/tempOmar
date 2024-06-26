import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Screens/simialrDrugs.dart';
import 'package:graduation_project/components/button.dart';
import 'package:graduation_project/helpers/snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Providers/UserProvider.dart';

class similarDrugDetails extends StatefulWidget {
  final String id;

  similarDrugDetails({Key? key, required this.id}) : super(key: key);


  @override
  State<similarDrugDetails> createState() => _similarDrugDetailsState();
}

class _similarDrugDetailsState extends State<similarDrugDetails> {

  @override
  void initState() {
    super.initState();
    _loadDrugDetails();
  }

  Future<void> _loadDrugDetails() async {
    Provider.of<UserProvider>(context, listen: false);
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title:Text(
          'Similar Drug Details',
          style: GoogleFonts.righteous(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.w900
          ),),
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: FutureBuilder(
        future: userProvider.getDrugDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:Lottie.asset(
              'assets/Loading.json',
              height: 300,
              width: 300,
            ),);
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error!'));
          }

          final drug = snapshot.data as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            drug['name'] as String? ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'ActiveIngredient: ${drug['activeIngredient'] as String? ?? 'No '}',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Price: ${drug['price'] as num? ?? ''} EGP',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 20),

                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomButton(
                        size: 25,
                        text: 'Add To Cart',
                        onTap: () {
                          int quantity = 1;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Quantity',
                                          style: GoogleFonts.righteous(
                                              color: Colors.green,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w900
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (quantity > 1) quantity--;
                                                });
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              quantity.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  quantity++;
                                                });
                                              },
                                              icon: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await userProvider.addToCart(widget.id,quantity);
                                          Navigator.of(context).pop();
                                          showSnackBar(context, "Added To Cart");
                                        },
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        },
      ),
    );
  }
}
