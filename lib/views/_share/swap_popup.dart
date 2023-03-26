import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

void swapConfirmationDialog(BuildContext pageCtx, String coursename, int cur,
    int wanted, void Function() runner) {
  showDialog<void>(
    context: pageCtx,
    builder: (dialogCtx) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            coursename,
            style: Theme.of(pageCtx).textTheme.titleMedium!,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CL${cur.toString().padLeft(2, '0')}",
                style: Theme.of(pageCtx).textTheme.titleMedium!,
              ),
              const Icon(Icons.arrow_forward),
              Text(
                "CL${wanted.toString().padLeft(2, '0')}",
                style: Theme.of(pageCtx).textTheme.titleMedium!,
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogCtx);
            runner();
          },
          child: Text(pageCtx.getString("swap")),
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
