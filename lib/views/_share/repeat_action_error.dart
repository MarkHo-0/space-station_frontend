import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void repeatActionErrorDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.getString('repeat_err_title')),
      content: Text(context.getString('repeat_err_body')),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.getString('back')))
      ],
    ),
  );
}
