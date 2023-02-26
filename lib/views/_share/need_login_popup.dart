import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_pages/login_lobby.dart';

void showNeedLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          context.getString("feature_need_login"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.getString('back'),
              style: TextStyle(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: ((_) => const LoginLobby()),
                ),
              );
            },
            child: Text(context.getString('login_action')),
          )
        ],
      );
    },
  );
}
