import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../_share/loadable_button.dart';
import '../_share/unknown_error_popup.dart';
import '../../api/error.dart';
import '../../providers/auth_provider.dart';

class PasswordInputPage extends StatefulWidget {
  final int studentID;

  const PasswordInputPage(this.studentID, {super.key});

  @override
  State<PasswordInputPage> createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends State<PasswordInputPage> {
  final passwordController = TextEditingController();
  final passwordField = FocusNode();
  bool isLoading = false;
  bool isPwdCorrect = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.getString('page_login')),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
        child: Column(children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              context.getString('field_password'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              enabled: !isLoading,
              controller: passwordController,
              focusNode: passwordField,
              autofocus: true,
              obscureText: true,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20)
              ],
              decoration: InputDecoration(
                errorText: isPwdCorrect
                    ? null
                    : context.getString('field_password_incorrect'),
              ),
              keyboardType: TextInputType.visiblePassword,
              onEditingComplete: () => onSumbitPassword(context),
              onChanged: (_) {
                if (!isPwdCorrect) {
                  setState(() => isPwdCorrect = true);
                }
              },
            ),
          ),
          const SizedBox(height: 50),
          LoadableButton(
            text: context.getString('login_action'),
            isLoading: isLoading,
            onPressed: () => onSumbitPassword(context),
          ),
        ]),
      ),
    );
  }

  void onSumbitPassword(BuildContext context) {
    final password = passwordController.text;
    if (password.isEmpty) return;

    setLoading(true);

    Provider.of<AuthProvider>(context, listen: false)
        .login(widget.studentID, password)
        .then((_) => Navigator.of(context).pop())
        .catchError(onIncorrectPassword, test: (e) => e is AuthorizationError)
        .onError((_, __) => showUnkownErrorDialog(context))
        .whenComplete(() => setLoading(false));
  }

  void setLoading(bool b) {
    setState(() => isLoading = b);
  }

  void onIncorrectPassword(err) {
    setState(() => isPwdCorrect = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      passwordController.clear();
      passwordField.requestFocus();
    });
  }
}
