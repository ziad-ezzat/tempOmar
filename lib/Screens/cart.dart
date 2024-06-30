import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Providers/CartProvider.dart';
import 'package:graduation_project/Screens/Checkout.dart';
import 'package:graduation_project/helpers/snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final cartData = cartProvider.cart;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Cart',
            style: GoogleFonts.righteous(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.w900,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.green),
        ),
        body: cartData == null
            ? Center(
                child: Lottie.asset(
                  'assets/Loading.json',
                  height: 300,
                  width: 300,
                ),
              )
            : Column(
                children: [
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
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: cartData?.items.length ?? 0,
                          itemBuilder: (context, index) {
                            final cartItem = cartData!.items[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 20.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      cartItem.drug.name,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      'Quantity: ${cartItem.quantity}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      'Price: ${cartItem.price} EGP',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        content: const Text(
                                                          'Are you sure you want to delete this item?',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await cartProvider
                                                                  .deleteDrugFromCart(
                                                                      cartItem
                                                                          .id);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              showSnackBar(
                                                                  context,
                                                                  "Drug Deleted");
                                                            },
                                                            child: const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.delete_forever,
                                                    size: 25,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green.shade200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Price: $totalPrice EGP',
                              style: GoogleFonts.anton(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade300,
                            ),
                            child: Text(
                              'Checkout',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.anton(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
