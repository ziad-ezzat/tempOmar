import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> orderHistoryFuture;

  const OrderHistoryScreen({Key? key, required this.orderHistoryFuture});

  @override

  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}


class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  void initState() {
    super.initState();
    setState(() {
      Provider.of<UserProvider>(context, listen: false).loadUserProfile();
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Order History',
          style: GoogleFonts.righteous(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:  widget.orderHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:Lottie.asset(
              'assets/Loading.json',
              height: 300,
              width: 300,
            ),
            );
          } else if (snapshot.hasData) {
            final orderHistory = snapshot.data!;
            return ScrollbarTheme(
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
                  itemCount: orderHistory.length,
                  itemBuilder: (context, index) {
                    final OrderHistory = orderHistory[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 150,
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/carts.png',
                                    height: 60,
                                    width: 40,
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        OrderHistory['shippingAddress'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.russoOne(
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        OrderHistory['phone'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.russoOne(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        OrderHistory['paymentMethod'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.russoOne(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        OrderHistory['status'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.russoOne(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${OrderHistory['totalPrice']} EGP',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.russoOne(
                                      fontSize: 15, color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Error loading Order history.'),
            );

          }

        },

      ),
    );

  }
}

