import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:space_station/views/login_pages/login_lobby.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('page_regester'.i18n()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.done_outline,
              color: Theme.of(context).primaryColor,
              size: 100,
            ),
            Text(
              'regester_successed'.i18n(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const LoginLobby(),
                  ));
                },
                child: Text('back'.i18n()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
