import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/auth_provider.dart';
import 'package:space_station/views/login_pages/login_lobby.dart';
import 'package:rive/rive.dart';

class WellcomeBox extends StatelessWidget {
  const WellcomeBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        color: const Color.fromRGBO(38, 45, 67, 1),
        child: Ink(
          height: 172,
          child: InkWell(
            onTap: () => {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
              child: Consumer<AuthProvider>(builder: (context, auth, _) {
                return auth.isLogined
                    ? buildWellcomeScreen(context, auth.user!.nickname)
                    : buildDefaultScreen(context);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDefaultScreen(BuildContext context) {
    const kColor = Color.fromRGBO(192, 206, 255, 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect to the Space Station',
                style: TextStyle(
                  fontSize: 16,
                  color: kColor,
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () => onGoToLoginPage(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kColor,
                  side: const BorderSide(width: 1.5, color: kColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  child: Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
        RiveAnimation.asset('assets/animations/spinning_animation.riv'),
      ],
    );
  }

  void onGoToLoginPage(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: ((_) => const LoginLobby())),
    );
  }

  Widget buildWellcomeScreen(BuildContext context, String username) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/welcome.png',
              width: 130,
            ),
            Text(
              username,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(192, 206, 255, 1),
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
        Image.asset('assets/images/people.png'),
      ],
    );
  }
}
