import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Providers/UserProvider.dart';
import '../components/button.dart';
import '../helpers/snackbar.dart';
import 'EditUsername.dart';
import 'OrderHistoryScreen.dart';
import 'SearchHistoryScreen.dart';
import 'login.dart';

// Profile widget
class Profile extends StatefulWidget {
  final String? newUsername;

  const Profile({Key? key, this.newUsername}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = true;
  String? updatedUsername;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .loadUserProfile()
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void updateUsername(String newUsername) {
    setState(() {
      updatedUsername = newUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context);
    final user = userInfo.user;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            "assets/logo.png",
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        body: Center(
          child:Lottie.asset(
            'assets/Loading.json',
            height: 300,
            width: 300,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          width: 100,
          fit: BoxFit.contain,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            'assets/profile.png',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                      IconButton(
                        onPressed: () async {
                          await userInfo.logOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                          showSnackBar(context, "Logout Successfully ");
                        },
                        icon: const Icon(
                          Icons.login_outlined,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                width: 250,
                child: Divider(
                  color: CupertinoColors.activeGreen,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(
                        Icons.person_pin,
                        color: Colors.green,
                      ),
                      title: Row(
                        children: [
                          Text(
                            updatedUsername ?? widget.newUsername ?? user?.userName ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textWidthBasis: TextWidthBasis.longestLine,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: () async {
                              final newUserName = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditUsername()),
                              );
                              if (newUserName != null) {
                                try {
                                  await Provider.of<UserProvider>(context, listen: false)
                                      .updateUserName(newUserName);
                                  updateUsername(newUserName);
                                  showSnackBar(context, 'Username updated successfully.');
                                } catch (error) {
                                  showSnackBar(context, error.toString());
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(
                        Icons.email_rounded,
                        color: Colors.green,
                      ),
                      title: Text(
                        user?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(
                        Icons.date_range,
                        color: Colors.green,
                      ),
                      title: Text(
                        user?.createdAt.toString() ?? '',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: Colors.green,
                      ),
                      title: Text(
                        userInfo.user?.role ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Search History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchHistoryScreen(
                        searchHistoryFuture: Future.value(user!.searchHistory),
                      ),
                    ),
                  );
                },
                size: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Order History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryScreen(
                        orderHistoryFuture: Future.value(user!.orderHistory),
                      ),
                    ),
                  );
                },
                size: 20,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
