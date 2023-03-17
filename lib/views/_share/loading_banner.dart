import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingBanner extends StatelessWidget {
  const LoadingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Theme.of(context).primaryColor,
        BlendMode.srcIn,
      ),
      child: const AspectRatio(
        aspectRatio: 6 / 1,
        child: RiveAnimation.asset('assets/animations/stars_twinkle.riv'),
      ),
    );
  }
}
