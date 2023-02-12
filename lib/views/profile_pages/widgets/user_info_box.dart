import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../login_pages/login_lobby.dart';
import 'stats_counter.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getNickname(context, auth),
            style: Theme.of(context).textTheme.headlineMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          buildRightSidePanel(context, auth),
        ],
      ),
    );
  }

  Widget buildRightSidePanel(BuildContext context, AuthProvider auth) {
    if (auth.isLogined) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StatsCounter(
            name: context.getString("thread_stat"),
            quantity: 0,
            onTap: () {},
          ),
          const SizedBox(width: 24),
          StatsCounter(
            name: context.getString("comment_stat"),
            onTap: () {},
            quantity: 0,
          ),
        ],
      );
    }
    return TextButton(
      onPressed: () => onPressedLogin(context),
      child: Text(context.getString("login_action")),
    );
  }

  String getNickname(BuildContext context, AuthProvider auth) {
    if (auth.isLogined) return auth.user!.nickname;
    return context.getString("guest_nickname");
  }

  void onPressedLogin(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: ((_) => const LoginLobby())),
    );
  }
}
