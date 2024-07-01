import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/components/TextFormField.dart';
import 'package:graduation_project/components/button.dart';
import 'package:graduation_project/helpers/snackbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../Providers/UserProvider.dart';
class EditUsername extends StatefulWidget {
  @override
  State<EditUsername> createState() => _EditUsernameState();
}

class _EditUsernameState extends State<EditUsername> {
  bool isLoading = false;
  bool isApiCallProcess = false;
  TextEditingController? usernameController;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    usernameController!.text = '';
  }

  @override
  void dispose() {
    usernameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: globalFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green.withOpacity(0.2),
                          Colors.greenAccent
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(110),
                        bottomRight: Radius.circular(110),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/profile.png",
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Edit Username",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoCondensed(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  defaultTextForm(
                    controller: usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username is required';
                      }
                      if (value.length < 4) {
                        return 'Username must be at least 4 characters long';
                      }
                      if (value.length > 20) {
                        return 'Username must be less than 20 characters long';
                      }
                      return null;
                    },
                    pref: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    labelText: 'New Username',
                    hintText: "Enter your new username",
                    onChanged: (data) {
                      return data;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    size: 25,
                    text: 'Save',
                    onTap: () async {
                      if (globalFormKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await Provider.of<UserProvider>(context, listen: false)
                              .updateUserName(usernameController!.text);
                          Navigator.pop(context, usernameController!.text);
                        } catch (error) {
                          showSnackBar(context, error.toString());
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
