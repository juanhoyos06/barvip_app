import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyStyles {
  SnackBar snackbar(String labelText, Color backgroundColor) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        labelText,
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
      duration: Duration(seconds: 2),
    );
  }
}