import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_station/api/interfaces/user_api.dart';
import 'package:space_station/views/_share/failed_page.dart';
import 'package:space_station/views/login_pages/user_banned.dart';
import 'package:space_station/views/login_pages/user_pwd.dart';
import 'package:space_station/views/login_pages/user_vf.dart';

class LoginLobby extends StatefulWidget {
  const LoginLobby({super.key});

  @override
  State<LoginLobby> createState() => _LoginLobbyState();
}

class _LoginLobbyState extends State<LoginLobby> {
  final sidController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 60, 50, 0),
        child: Column(children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Student ID:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              maxLength: 8,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '00000000',
                counterText: "",
              ),
              controller: sidController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEditingComplete: () => onPressNext(context),
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () => onPressNext(context),
            child: const Text('Next'),
          )
        ]),
      ),
    );
  }

  void onPressNext(BuildContext context) {
    //檢驗學生編號是否合法
    if (sidController.text.length != 8) return;
    final sid = int.parse(sidController.text);
    if (sid < 20000000 || sid > 30000000) return;
    //向伺服器查詢學生編號
    getUserState(sid).then((userStatus) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) {
          switch (userStatus) {
            case 0:
              return EmailVerificationPage(sid);
            case 1:
              return PasswordInputPage(sid);
            case 2:
              return UserBannedPage(sid);
          }
          return const FailedPage();
        })),
      );
    }).onError((err, _) => null); //TODO: 錯誤處理
  }
}
