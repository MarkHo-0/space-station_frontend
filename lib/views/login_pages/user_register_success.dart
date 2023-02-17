import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/_share/loadable_button.dart';
import 'package:space_station/views/login_pages/login_lobby.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.getString('page_regester')),
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
              context.getString('regester_successed'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: LoadableButton(
                isLoading: false,
                text: context.getString('back'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const LoginLobby(),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
