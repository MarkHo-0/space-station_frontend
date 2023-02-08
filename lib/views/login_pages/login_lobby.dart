import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api/interfaces/user_api.dart';
import '../_share/loadable_button.dart';
import './user_banned.dart';
import './user_pwd.dart';
import './user_vf.dart';

import '../_share/unknown_error_popup.dart';

class LoginLobby extends StatefulWidget {
  const LoginLobby({super.key});

  @override
  State<LoginLobby> createState() => _LoginLobbyState();
}

class _LoginLobbyState extends State<LoginLobby> {
  final sidController = TextEditingController();
  bool isLoading = false;
  bool isSidValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.getString('page_login')),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 60, 50, 0),
        child: Column(children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              context.getString('field_sid'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              enabled: !isLoading,
              maxLength: 8,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.getString('field_sid_hint'),
                counterText: "",
                errorText:
                    isSidValid ? null : context.getString('field_sid_invlid'),
              ),
              controller: sidController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEditingComplete: () => onPressNext(context),
            ),
          ),
          const SizedBox(height: 50),
          LoadableButton(
            text: context.getString('next'),
            isLoading: isLoading,
            onPressed: () => onPressNext(context),
          ),
        ]),
      ),
    );
  }

  void onPressNext(BuildContext context) {
    //檢驗學生編號是否合法
    final sid = int.tryParse(sidController.text) ?? 0;
    if (sid < 20000000 || sid > 30000000) {
      sidController.clear();
      return setState(() => isSidValid = false);
    }

    setState(() {
      isSidValid = true;
      isLoading = true;
    });

    //向伺服器查詢學生編號
    getUserState(sid).then((userStatus) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          if (userStatus == 0) return EmailVerificationPage(sid);
          if (userStatus == 1) return PasswordInputPage(sid);
          return UserBannedPage(sid);
        }),
      );
    }).catchError((_) {
      showUnkownErrorDialog(context);
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }
}
