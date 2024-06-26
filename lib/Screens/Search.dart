import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduation_project/Providers/UserProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'DrugDetails.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _searchController;
  int page = 1;
  String query = '';
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drugsProvider = Provider.of<UserProvider>(context);
    final drugs = drugsProvider.drugsSearch;
    final totalDrugs = drugsProvider.totalDrugsSearch;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title:
        TextField(
          style:const TextStyle(
            fontFamily: "Open Sans",
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding:const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[600],
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  query = "";
                });
              },
            ),
            hintStyle: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:const BorderSide(
                color: Colors.green,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
          ),
          onSubmitted: (value) async {
            setState(() {
              query = value;
              isLoading = true;
              isError = false;
            });
            try {
              await Provider.of<UserProvider>(context, listen: false).searchDrugs(query, 1);
            } catch (e) {
              setState(() {
                isError = true;
              });
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          },
        ),


      ),
      body: _searchController.text.isEmpty
          ? SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
                Text(
                  "Search for Drugs!",
                  style: GoogleFonts.righteous(
                      color: Colors.green,
                      fontSize: 35,
                      fontWeight: FontWeight.w900
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Image.asset('assets/search.png', height: 100,)
              ],
            ),
          ),
        ),
      ): isLoading // show progress indicator while searching
          ? Center(
        child:Lottie.asset(
          'assets/Loading.json',
          height: 300,
          width: 300,
        ),
      ): isError // show error message if search failed
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:const [
             Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red,
            ),
             SizedBox(height: 16),
             Text(
              'Drug Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(top: 10),
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
              itemCount: drugs.length,
              itemBuilder: (BuildContext context, int index) {
                final drug = drugs[index];
                final name = drug['name'] as String? ?? '';
                final activeIngredient = drug['activeIngredient'] as String? ?? '';
                final id = drug['_id'] as String? ?? '';
                final price = drug['price'] as num?;
                final priceText = price != null ? '$price EGP' : '';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrugDetails(id: id)
                      ),
                    );
                  },
                  child: Padding(
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
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.russoOne(
                                          fontSize: 15,
                                        )
                                    ),
                                    Text(
                                        activeIngredient,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.russoOne(
                                          fontSize: 12,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                  priceText,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.russoOne(
                                      fontSize: 15,
                                      color: Colors.red
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );

              }, separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(
              height: 25,
            ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: Visibility(
        visible: _searchController.text.isNotEmpty && !isError,
        child: Container(
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
                    onPressed: (page > 1 && !isLoading)
                        ? () async {
                      setState(() {
                        isLoading = true;
                        page--;
                      });
                      await drugsProvider.previousPageSearch(query);
                      setState(() {
                        isLoading = false;
                      });
                    }
                        : null,
                  ),
                  GButton(
                    icon: Icons.keyboard_double_arrow_right_outlined,
                    text: 'Next',
                    onPressed: ((page - 1) * 10 < totalDrugs && !isLoading)
                        ? () async {
                      setState(() {
                        isLoading = true;
                        page++;
                      });
                      await drugsProvider.nextPageSearch(query);
                      setState(() {
                        isLoading = false;
                      });
                    }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),



    );
  }

}




