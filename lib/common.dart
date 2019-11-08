import 'package:flutter/material.dart';

const RunTitle = 'Run Buttons';
const HelpURL = 'https://github.com/gentee/run_buttons_phone';

enum Status {
  init,
  login,
  list,
}

alertDialog(context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            color: Colors.grey[200],
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}
