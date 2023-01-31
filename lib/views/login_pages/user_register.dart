import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:space_station/api/interfaces/user_api.dart' show registerUser;
import 'package:space_station/views/login_pages/user_register_success.dart';

final pwdChecker = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

class RegisterPage extends StatelessWidget {
  final int studentID;
  RegisterPage(this.studentID, {super.key});

  final inputFormKey = GlobalKey<FormState>();
  final nickname = TextEditingController();
  final password = TextEditingController();
  final cpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('page_regester'.i18n()),
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
                  'field_nickname'.i18n(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: nickname,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'field_nickname_hint'.i18n(),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return 'field_is_required'.i18n();
                  }
                  name = name.trim();
                  if (name.length < 2) {
                    return 'field_min_len'.i18n(['2']);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              //密碼
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'field_password'.i18n(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'field_password_hint'.i18n(),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                validator: (pwd) {
                  if (pwd == null || pwd.isEmpty) {
                    return 'field_is_required'.i18n();
                  }
                  if (pwdChecker.hasMatch(pwd) == false) {
                    return 'field_password_easy'.i18n();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              //確認密碼
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'field_cpassword'.i18n(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: cpassword,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                decoration: InputDecoration(
                  hintText: 'field_cpassword_hint'.i18n(),
                ),
                validator: (rpwd) {
                  if (rpwd == null || rpwd.isEmpty) {
                    return 'field_is_required'.i18n();
                  }
                  if (rpwd != password.text) {
                    return 'field_cpassword_notmatch'.i18n();
                  }
                  return null;
                },
                onEditingComplete: () => onSumbitForm(context),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => onSumbitForm(context),
                child: Text('finish'.i18n()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSumbitForm(BuildContext context) {
    if (!inputFormKey.currentState!.validate()) return;
    registerUser(studentID, password.text, nickname.text).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const RegisterSuccessPage(),
        ),
      );
    }).onError((error, stackTrace) => null);
  }
}
