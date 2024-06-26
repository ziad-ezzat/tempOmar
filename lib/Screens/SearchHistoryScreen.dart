import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:graduation_project/helpers/snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchHistoryScreen extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> searchHistoryFuture;

  const SearchHistoryScreen({
    Key? key,
    required this.searchHistoryFuture,
  }) : super(key: key);

  @override

  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}


class _SearchHistoryScreenState extends State<SearchHistoryScreen> {

  bool deleting = false;
  GlobalKey<_SearchHistoryScreenState> searchHistoryScreenKey =
  GlobalKey<_SearchHistoryScreenState>();
  void initState() {
    super.initState();
    setState(() {
      Provider.of<UserProvider>(context, listen: false).loadUserProfile();
    });
  }

  Future<void> deleteAndReloadHistory() async {
    setState(() {
      deleting = true;
    });

    await Provider.of<UserProvider>(context, listen: false).deleteAllHistory();

    setState(() {
      deleting = false;
    });

    showSnackBar(context, "History deleted successfully");

    // Update the searchHistoryFuture by calling the loadUserProfile method again
    Provider.of<UserProvider>(context, listen: false).loadUserProfile();

    // Go back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Search History',
            style: GoogleFonts.righteous(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.green),
        ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.searchHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/Loading.json',
                height: 300,
                width: 300,
              ),
            );
          } else if (snapshot.hasData) {
            final searchHistory = snapshot.data!;
            if (searchHistory.isEmpty) {
              return Center(
                child: Text(
                  'No History',
                  style: GoogleFonts.righteous(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              );
            }
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
                    itemCount: searchHistory.length,
                    itemBuilder: (context, index) {
                      final drugHistory = searchHistory[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 100,
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
                                      'assets/drugs.png',
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
                                          drugHistory['name'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.russoOne(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          drugHistory['category'] ?? '',
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
                                    '${drugHistory['price']} EGP',
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
                child: Text('Error loading search history.'),
              );

            }

          },

        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: deleting ? null : deleteAndReloadHistory,
        child: deleting
            ? Lottie.asset(
          'assets/Loading.json',
          height: 300,
          width: 300,
        )
            : Icon(Icons.delete, color: Colors.red),
      ),



    );

  }
}

