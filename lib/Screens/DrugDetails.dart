import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Providers/CartProvider.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:graduation_project/Screens/simialrDrugs.dart';
import 'package:graduation_project/components/button.dart';
import 'package:graduation_project/helpers/snackbar.dart';
import 'package:graduation_project/models/cartModel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DrugDetails extends StatefulWidget {
  final String id;

  const DrugDetails({super.key, required this.id});

  @override
  State<DrugDetails> createState() => _DrugDetailsState();
}

class _DrugDetailsState extends State<DrugDetails> {
  @override
  void initState() {
    super.initState();
    _loadDrugDetails();
  }

  Future<void> _loadDrugDetails() async {
    Provider.of<CartProvider>(context, listen: false);
    Provider.of<UserProvider>(context, listen: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    String drugName = '';
    int drugPrice = 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Drug Details',
          style: GoogleFonts.righteous(
              color: Colors.green, fontSize: 35, fontWeight: FontWeight.w900),
        ),
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: FutureBuilder(
        future: userProvider.getDrugDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/Loading.json',
                height: 300,
                width: 300,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error!'));
          }

          final drug = snapshot.data as Map<String, dynamic>;
          drugName = drug['name'] as String? ?? '';
          drugPrice = drug['price'] as int? ?? 0;

          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
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
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Price: ${drug['price'] as num? ?? ''} EGP',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                  size: 25,
                  text: 'Similar Drugs',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SimilarDrugs(
                                drugId: widget.id,
                              )),
                    );
                  },
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
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Quantity',
                                          style: GoogleFonts.righteous(
                                              color: Colors.green,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          final drug = DrugModel(
                                              name: drugName);
                                          await cartProvider.addToCart(
                                              drug, quantity, drugPrice as int);
                                          Navigator.of(context).pop();
                                          showSnackBar(
                                              context, "Added To Cart");
                                        },
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
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
