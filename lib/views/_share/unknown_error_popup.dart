import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void showUnkownErrorDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.getString('unknown_err_title')),
      content: Text(context.getString('unknown_err_solution')),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.getString('back')))
      ],
    ),
  );
}
