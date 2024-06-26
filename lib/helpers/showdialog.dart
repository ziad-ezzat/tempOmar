import 'dart:async';

import 'package:flutter/material.dart';


class MyDialog extends StatefulWidget {
  final String title;
  final int duration;

  const MyDialog({super.key, required this.title, required this.duration});

  @override
  MyDialogState createState() => MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  late int _countdownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialize the countdown timer
    _countdownSeconds = widget.duration;
    // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Update the countdown timer
        _countdownSeconds--;
      });
      // Check if the timer has expired
      if (_countdownSeconds == 0) {
        // Cancel the timer
        _timer!.cancel();
        // Close the dialog
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content:Column(
        mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/accept.png',
        height: 100,
        width: 80,
        ), // Add an image to the top of the dialog
        const SizedBox(height: 30),
        Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:FontWeight.w900,

            )),
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.topRight,
            child: Text('Will close in $_countdownSeconds seconds.',
            style: const TextStyle
              (
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.red
            ),)
        ),
      ],
    ),
    );
  }
}

void show(BuildContext context, {required String title}) async {
  // Set the duration for the timer (in seconds)
  int durationInSeconds = 10;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Build the dialog widget with the countdown timer
      return MyDialog(
          title: title,
          duration: durationInSeconds);
    },
  );
}











// showAlertDialog(BuildContext context, {required String title}) {
//
//   // set up the button
//
//
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text(title),
//     content: Text('Will close after'),
//     actions: [
//       ElevatedButton(
//           onPressed: ()=>Navigator.pop(context),
//           child: const Text('OK',style: TextStyle(
//         color: Colors.black,
//         fontSize: 20
//       ),)),
//
//     ],
//   );
//
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       int durationInSeconds = 10;
//       Future.delayed(Duration(seconds: durationInSeconds), () {
//         // Pop the dialog after the timer expires
//         Navigator.of(context).pop();
//       });
//
//       return alert;
//     },
//   );
// }