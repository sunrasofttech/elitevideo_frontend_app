import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AppToast {
  static void showSuccess(BuildContext context, String title, String msg) {
    _showSnackBar(context, title, msg, ContentType.success);
  }

  static void showError(BuildContext context, String title, String msg) {
    _showSnackBar(context, title, msg, ContentType.failure);
  }

  static void showWarning(BuildContext context, String title, String msg) {
    _showSnackBar(context, title, msg, ContentType.warning);
  }

  static void showInfo(BuildContext context, String title, String msg) {
    _showSnackBar(context, title, msg, ContentType.help);
  }

  static void _showSnackBar(BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
