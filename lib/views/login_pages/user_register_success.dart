import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../_share/loadable_button.dart';
import 'login_lobby.dart';

class RegisterSuccessPage extends StatefulWidget {
  const RegisterSuccessPage({super.key});

  @override
  State<RegisterSuccessPage> createState() => _RegisterSuccessPageState();
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController uiCtl;
  late RocketAnimation rocketAnimation;

  @override
  void initState() {
    super.initState();
    uiCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    //火箭發射動畫開始播放300毫秒後顯示界面
    rocketAnimation = RocketAnimation(() {
      Future.delayed(const Duration(milliseconds: 300), () => uiCtl.forward());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.getString('page_register')),
      ),
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: RiveAnimation.asset(
                'assets/animations/rocket_launch.riv',
                controllers: [rocketAnimation],
              ),
            ),
            FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(uiCtl),
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.1),
                  end: const Offset(0, 0),
                ).animate(uiCtl),
                child: SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.getString('register_successed'),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: LoadableButton(
                          isLoading: false,
                          text: context.getString('back'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) => const LoginLobby(),
                            ));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RocketAnimation extends OneShotAnimation {
  final Function() onPlay;
  RocketAnimation(this.onPlay) : super('go_up');

  @override
  void onActiveChanged() {
    //解決播放後會顯示首幀的問題
    if (isActive) onPlay.call();
  }
}
