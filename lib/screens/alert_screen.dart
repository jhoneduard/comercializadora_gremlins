import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertScreen {
  static displayDialogIOS(
      {required BuildContext context,
      required String titulo,
      required String text,
      required String url}) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(text)],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, url),
                  child: const Icon(Icons.arrow_circle_left_sharp)),
            ],
          );
        });
  }

  static displayDialogAndroid(
      {required BuildContext context,
      required String titulo,
      required String text,
      required String url}) {
    return showDialog(
        // Cerrar dialog al darle click en la zona gris
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: Text(titulo),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(text)],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, url),
                  child: const Icon(Icons.arrow_circle_left_sharp)),
            ],
          );
        });
  }
}
