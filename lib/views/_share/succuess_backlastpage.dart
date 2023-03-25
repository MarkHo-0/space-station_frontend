import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void succussandbacklastpageDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        context.getString('success_message'),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(context.getString('back')))
      ],
    ),
  );
}
