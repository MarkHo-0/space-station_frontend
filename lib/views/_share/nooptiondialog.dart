import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void noOptionDialog(BuildContext context, String localizationString) {
  showDialog<void>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      content: Text(
        context.getString(localizationString),
        style: Theme.of(context).textTheme.titleMedium!,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx),
          child: Text(
            context.getString("back"),
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
      ],
    ),
  );
}
