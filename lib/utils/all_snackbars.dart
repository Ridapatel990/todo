import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class AllSnackbars {
  static void showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      padding: EdgeInsets.zero,

      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,

      backgroundColor: Colors.transparent,
      elevation: 0, 
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
