import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget CustomButton({
  required String text,
  required double size,
  required VoidCallback? onTap,
}) => Container(
  width: double.infinity,
  margin: EdgeInsets.symmetric(horizontal: 100),
  child: Material(
    color: Colors.green.withOpacity(0.7),
    borderRadius: BorderRadius.circular(30),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.gemunuLibre(
              textStyle: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
