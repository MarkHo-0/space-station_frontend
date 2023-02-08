import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_station/views/_share/loadable_button.dart';
import '../../api/interfaces/user_api.dart' show registerUser;
import '../_share/unknown_error_popup.dart';
import './user_register_success.dart';

final pwdChecker = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

class RegisterPage extends StatefulWidget {
  final int studentID;
  const RegisterPage(this.studentID, {super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final inputFormKey = GlobalKey<FormState>();
  final nickname = TextEditingController();
  final password = TextEditingController();
  final cpassword = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.getString('page_regester')),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
        child: Form(
          key: inputFormKey,
          child: Column(
            children: [
              //用戶名稱
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  context.getString('field_nickname'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                enabled: !isLoading,
                controller: nickname,
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: context.getString('field_nickname_hint'),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return context.getString('field_is_required');
                  }
                  name = name.trim();
                  if (name.length < 2) {
                    return context.getString('field_min_len');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              //密碼
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  context.getString('field_password'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                enabled: !isLoading,
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: context.getString('field_password_hint'),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                validator: (pwd) {
                  if (pwd == null || pwd.isEmpty) {
                    return context.getString('field_is_required');
                  }
                  if (pwdChecker.hasMatch(pwd) == false) {
                    return context.getString('field_password_easy');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              //確認密碼
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  context.getString('field_cpassword'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                enabled: !isLoading,
                controller: cpassword,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                decoration: InputDecoration(
                  hintText: context.getString('field_cpassword_hint'),
                ),
                validator: (rpwd) {
                  if (rpwd == null || rpwd.isEmpty) {
                    return context.getString('field_is_required');
                  }
                  if (rpwd != password.text) {
                    return context.getString('field_cpassword_notmatch');
                  }
                  return null;
                },
                onEditingComplete: () => onSumbitForm(context),
              ),
              const SizedBox(height: 30),
              LoadableButton(
                text: context.getString('finish'),
                isLoading: isLoading,
                onPressed: () => onSumbitForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSumbitForm(BuildContext context) {
    if (!inputFormKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    registerUser(widget.studentID, password.text, nickname.text).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const RegisterSuccessPage(),
        ),
      );
    }).catchError((_) {
      showUnkownErrorDialog(context);
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }
}
