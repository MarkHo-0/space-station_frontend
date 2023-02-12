import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/auth_provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        InkWell(
          onTap: () => onClicked(context),
          child: Ink(
            padding: const EdgeInsets.all(3),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                context.getString("logout_action"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  void onClicked(BuildContext contextDef) {
    showDialog(
        context: contextDef,
        builder: (context) {
          return AlertDialog(
            title: Text(context.getString('conform_logout')),
            actions: [
              TextButton(
                onPressed: () =>
                    Provider.of<AuthProvider>(context, listen: false)
                        .logout()
                        .whenComplete(() {
                  Navigator.pop(context);
                }),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                child: Text(
                  context.getString("logout_action"),
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.getString("cancel")),
              ),
            ],
          );
        });
  }
}
