import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void showRemoveConfirmation(BuildContext pageCtx, void Function() runner) {
  showDialog<void>(
    context: pageCtx,
    builder: (dialogCtx) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      content: Text(
        pageCtx.getString("before_remove_confirm"),
        style: Theme.of(pageCtx).textTheme.titleMedium!,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogCtx);
            runner();
          },
          child: Text(pageCtx.getString("conform")),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx),
          child: Text(
            pageCtx.getString("cancel"),
            style: TextStyle(color: Theme.of(pageCtx).disabledColor),
          ),
        ),
      ],
    ),
  );
}
