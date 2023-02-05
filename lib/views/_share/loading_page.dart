import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1,
        child: Transform.scale(
          scale: 1.5,
          child: const RiveAnimation.asset(
            'assets/animations/spaceman_jump.riv',
            fit: BoxFit.contain,
            animations: ['Timeline 1', 'Timeline 2'],
          ),
        ),
      ),
    );
  }
}
