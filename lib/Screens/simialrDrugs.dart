import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:graduation_project/Screens/similarDrugDetails.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/drugsModel.dart';

class SimilarDrugs extends StatefulWidget {
  final String drugId;

  const SimilarDrugs({Key? key, required this.drugId}) : super(key: key);

  @override
  State<SimilarDrugs> createState() => _SimilarDrugsState();
}


class _SimilarDrugsState extends State<SimilarDrugs> {
  bool hasMoreDrugs = true;
  String id='';
  int page = 1;
  bool isLoading = false;
  bool isError = false;
  late UserProvider userProvider;
  late Future<List<Drug>> similarDrugsFuture;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    similarDrugsFuture = userProvider.getSimilarDrugs(widget.drugId, page);
  }

  void nextPage() {
    setState(() {
      page++;
      similarDrugsFuture = userProvider.getSimilarDrugs(widget.drugId, page);
      hasMoreDrugs = userProvider.totalDrugsSimilar > page * 10;
    });
  }

  void prevPage() {
    setState(() {
      page--;
      similarDrugsFuture = userProvider.getSimilarDrugs(widget.drugId, page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title:Text(
          'Similar Drugs',
          style: GoogleFonts.righteous(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.w900
          ),),
        iconTheme: const IconThemeData(color: Colors.green),
      ),

      body: FutureBuilder<List<Drug>>(
        future: similarDrugsFuture,
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
            return Center(
              child: Text(
                'Not Found',
                style: GoogleFonts.righteous(
                color: Colors.green,
                fontSize: 35,
                fontWeight: FontWeight.w900
            ),),);
          }

          final drugs = snapshot.data!;

          if (drugs.isEmpty){
            hasMoreDrugs = false; // disable Next button
            return  Center(
                child:
                Text(
                  'No More Drugs',
                  style: GoogleFonts.righteous(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w900
                  ),),
            );
          }

          return Column(
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
                      itemCount: drugs.length,
                      itemBuilder: (context, index) {
                        final drug = drugs[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => similarDrugDetails(id: drug.id),
                              ),
                            );
                          },

                          child: Column(
                            children: [
                              Padding(
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
                                                 drug.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                'ActiveIngredient: ${drug.activeIngredient}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                'Price: ${drug.price} EGP',
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

                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
               ),

            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.green.shade300,
        ),
        child: Stack(
          children: [
            GNav(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.green,
              color: Colors.black,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.green.withOpacity(0.8),
              gap: 20,
              tabs: [
                GButton(
                  icon: Icons.keyboard_double_arrow_left_outlined,
                  text: 'Previous',
                  onPressed: page > 1 ? prevPage : null,
                ),
                GButton(
                  icon: Icons.keyboard_double_arrow_right_outlined,
                  text: 'Next',
                  onPressed: hasMoreDrugs ? nextPage : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
