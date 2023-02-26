import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

Future<bool?> showUnsaveDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          context.getString("unsave_warning_title"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        content: Text(context.getString("unsave_warning_body")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.getString('discard'),
              style: TextStyle(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.getString('cancel')),
          )
        ],
      );
    },
  );
}
