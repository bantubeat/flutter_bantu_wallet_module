import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class UiAlertHelpers {
  static void showSuccessToast(
    String message, {
    Color? backgroundColor,
    bool long = true,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: kIsWeb ? ToastGravity.TOP : ToastGravity.BOTTOM,
      timeInSecForIosWeb: long ? 5 : 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showErrorToast(String message, {bool long = true}) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: kIsWeb ? ToastGravity.TOP : ToastGravity.BOTTOM,
      timeInSecForIosWeb: long ? 5 : 1,
      webBgColor: 'linear-gradient(to right, #ff5f6d, #ffc371)',
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
