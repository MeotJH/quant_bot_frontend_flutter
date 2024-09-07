import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showQuantBotDialog(
    {required BuildContext context,
    required String title,
    required String content}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Column(
          children: [Text(content)],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('확인'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
