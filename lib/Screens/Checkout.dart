import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Providers/CartProvider.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:graduation_project/components/button.dart';
import 'package:graduation_project/helpers/snackbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../components/TextFormField.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double paymentMethodRadius = 0.0;
  bool isLoading = false;
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green.withOpacity(0.2),
                        Colors.greenAccent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
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
                  "Checkout",
                  style: GoogleFonts.robotoCondensed(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Please enter your Address';
                    }
                    return null;
                  },
                  controller: addressController,
                  pref: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.black,
                  ),
                  labelText: "Address",
                  hintText: "Enter your address",
                ),

                defaultTextForm(
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Please enter your Phone';
                    }
                    return null;
                  },
                  controller: phoneController,
                  type: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pref: const Icon(
                    Icons.phone_enabled,
                    color: Colors.black,
                  ),
                  labelText: "Phone",
                  hintText: "Enter your Phone",
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        secondaryActiveColor:Colors.green,
                        thumbColor:Colors.green,
                        inactiveColor:Colors.green.shade200,
                        activeColor: Colors.green,
                        value: paymentMethodRadius,
                        min: 0.0,
                        max: 2.0,
                        divisions: 2,
                        onChanged: (value) {
                          setState(() {
                            paymentMethodRadius = value;
                          });
                        },
                        label: getPaymentMethodLabel(paymentMethodRadius),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cash on Delivery',
                            style: TextStyle(
                              fontWeight: getPaymentMethodRadius('cashOnDelivery') == paymentMethodRadius
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            'PayPal',
                            style: TextStyle(
                              fontWeight: getPaymentMethodRadius('paypal') == paymentMethodRadius
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            'Credit Card',
                            style: TextStyle(
                              fontWeight: getPaymentMethodRadius('creditCard') == paymentMethodRadius
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  size: 25,
                  text: "Order",
                  onTap: () async {
                    if (globalFormKey.currentState!.validate()) {
                      String shippingAddress = addressController.text;
                      String phone = phoneController.text;
                      String paymentMethod= getPaymentMethod();
                      CartProvider cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

                      try {
                        setState(() {
                          isLoading=true;
                        });
                        await cartProvider.checkout(shippingAddress, phone, paymentMethod, userProvider);
                        Navigator.pop(context);
                        showSnackBar(context, "Ordered Successfully");
                      } catch (error) {
                        print('Error: $error');
                        showSnackBar(context, 'Error');
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getPaymentMethodLabel(double radius) {
    if (radius == 0.0) {
      return 'Cash on Delivery';
    } else if (radius == 1.0) {
      return 'PayPal';
    } else if (radius == 2.0) {
      return 'Credit Card';
    } else {
      return '';
    }
  }

  double getPaymentMethodRadius(String paymentMethod) {
    if (paymentMethod == 'cashOnDelivery') {
      return 0.0;
    } else if (paymentMethod == 'paypal') {
      return 1.0;
    } else if (paymentMethod == 'creditCard') {
      return 2.0;
    } else {
      return -1.0; // Invalid value
    }
  }

  String getPaymentMethod() {
    if (paymentMethodRadius == 0.0) {
      return 'cashOnDelivery';
    } else if (paymentMethodRadius == 1.0) {
      return 'paypal';
    } else if (paymentMethodRadius == 2.0) {
      return 'creditCard';
    } else {
      return ''; // Invalid value
    }
  }
}
