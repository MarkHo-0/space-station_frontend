import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:space_station/api/error.dart';
import 'package:space_station/providers/auth_provider.dart';

class PasswordInputPage extends StatelessWidget {
  final int studentID;
  final passwordController = TextEditingController();
  final passwordField = FocusNode();
  PasswordInputPage(this.studentID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
        child: Column(children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Password:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              controller: passwordController,
              focusNode: passwordField,
              autofocus: true,
              obscureText: true,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20)
              ],
              keyboardType: TextInputType.visiblePassword,
              onEditingComplete: () => onSumbitPassword(context),
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () => onSumbitPassword(context),
            child: const Text('Log in'),
          )
        ]),
      ),
    );
  }

  void onSumbitPassword(BuildContext context) {
    final password = passwordController.text;
    if (password.isEmpty) return;
    Provider.of<AuthProvider>(context, listen: false)
        .login(studentID, password)
        .then((_) => Navigator.of(context).pop())
        .onError((error, _) => handleLoginError(error as Exception));
  }

  void handleLoginError(Exception error) {
    if (error is AuthorizationError) {
      passwordController.clear();
      passwordField.requestFocus();
      return;
    }
  }
}
