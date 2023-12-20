import 'package:flutter/material.dart';

import '../constants/color.dart';

class GlobalMethod {
  static showErrorDialog({required String error, required BuildContext ctx}) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "kesalahan terjadi",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          content: Text(
            "$error",
            style: TextStyle(
                color: Constants.black,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                "Oke",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
