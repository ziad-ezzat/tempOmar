import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget defaultTextForm({
  required String? Function(String?)? validator,
   TextEditingController?  controller,
  required Icon? pref,
  IconData? suffix,
  TextInputType? type,
  Function()? suffixPressed,
  required String labelText,
  required String hintText,
  Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
  bool isPassword = false,
}) =>
    Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        inputFormatters:inputFormatters,
        obscureText: isPassword,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        keyboardType: type,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            prefixIcon: pref,
            suffixIcon: suffix != null
                ? IconButton(
                    icon: Icon(
                      suffix,
                      color: Colors.green,
                    ),
                    onPressed: suffixPressed,
                  )
                : null,
            contentPadding: const EdgeInsets.all(25),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black)),
      ),
    );
