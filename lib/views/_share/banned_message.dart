import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void showBannedMessageDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.getString("banned_message_title")),
      content: Text(context.getString("banned_message_body")),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.getString('back')))
      ],
    ),
  );
}
