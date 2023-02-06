import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

void showUnkownErrorDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('unknown_err_title'.i18n()),
      content: Text('unknown_err_solution'.i18n()),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('back'.i18n()))
      ],
    ),
  );
}
