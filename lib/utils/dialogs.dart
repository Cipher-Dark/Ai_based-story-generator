import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.black,
        elevation: 10,
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'bold',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.green[200],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSnackBarError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.black,
        elevation: 10,
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'bold',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.red[100],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
  }

  static showLoader() {
    return Image.asset("assets/icon/loader.gif");
  }
}
