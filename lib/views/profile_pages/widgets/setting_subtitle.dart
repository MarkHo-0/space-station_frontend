import 'package:flutter/material.dart';

class SettingSubtitle extends StatelessWidget {
  final String title;
  const SettingSubtitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 25),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).hintColor,
            ),
      ),
    );
  }
}
