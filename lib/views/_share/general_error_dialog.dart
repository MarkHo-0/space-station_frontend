import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

Future<void> showGeneralErrorDialog(BuildContext context, String contentKey) {
  return showDialog<void>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      content: Text(context.getString(contentKey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx),
          child: Text(context.getString("back")),
        ),
      ],
    ),
  );
}
