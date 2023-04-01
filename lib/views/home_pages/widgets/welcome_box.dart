import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../providers/auth_provider.dart';
import '../../login_pages/login_lobby.dart';

const _kLightBlue = Color.fromRGBO(192, 206, 255, 1);
const _kDarkBlue = Color.fromRGBO(38, 45, 67, 1);

class WelcomeBox extends StatelessWidget {
  WelcomeBox({Key? key}) : super(key: key);
  final animationKey = GlobalKey<ClickableAnimationState>();

  @override
  Widget build(BuildContext context) {
    final loginedUser = getLoginedUser(context);
    final design = loginedUser != null
        ? loginedDesign(context, loginedUser.nickname)
        : defaultDesign(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        color: _kDarkBlue,
        child: Ink(
          height: 172,
          child: InkWell(
            onTap: () => animationKey.currentState!.click(),
            child: design.finalize(context, animationKey),
          ),
        ),
      ),
    );
  }

  WelcomeBoxDesign defaultDesign(BuildContext context) {
    return WelcomeBoxDesign(
      animationFile: "rocket_idle.riv",
      children: [
        Text(
          context.getString("launch_rocket"),
          style: const TextStyle(fontSize: 16, color: _kLightBlue),
        ),
        const SizedBox(height: 15),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: ((_) => const LoginLobby())),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: _kLightBlue,
            side: const BorderSide(width: 1.5, color: _kLightBlue),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: Text(
              context.getString("login_action"),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  WelcomeBoxDesign loginedDesign(BuildContext context, String username) {
    return WelcomeBoxDesign(
      animationFile: "spaceman_spin.riv",
      children: [
        Text(
          context.getString("welcome_slogan"),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: _kLightBlue,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          username,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: _kLightBlue),
        )
      ],
    );
  }
}

class ClickableAnimation extends StatefulWidget {
  final String animationFile;
  const ClickableAnimation({
    super.key,
    required this.animationFile,
  });

  @override
  State<ClickableAnimation> createState() => ClickableAnimationState();
}

class ClickableAnimationState extends State<ClickableAnimation> {
  SMITrigger? _pressed;

  void _onRiveInit(Artboard artboard) {
    var ctl = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(ctl!);
    _pressed = ctl.inputs.first as SMITrigger;
  }

  void click() {
    if (_pressed == null) return;
    _pressed!.fire();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: RiveAnimation.asset(
        'assets/animations/${widget.animationFile}',
        onInit: _onRiveInit,
      ),
    );
  }
}

class WelcomeBoxDesign {
  final List<Widget> children;
  final String animationFile;

  const WelcomeBoxDesign({required this.children, required this.animationFile});

  Widget finalize(
      BuildContext context, GlobalKey<ClickableAnimationState> animationKey) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
          ClickableAnimation(
            key: animationKey,
            animationFile: animationFile,
          ),
        ],
      ),
    );
  }
}
