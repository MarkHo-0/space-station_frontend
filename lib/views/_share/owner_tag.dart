import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../utils/parse_time.dart';

class OwnerTag extends StatelessWidget {
  final User owner;
  final int lastUpdateTime;
  const OwnerTag(
      {super.key, required this.owner, required this.lastUpdateTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          owner.nickname,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
        const SizedBox(width: 10),
        Text(
          unixTime2DiffText(lastUpdateTime),
          style: const TextStyle(
            color: Color.fromRGBO(116, 116, 116, 1),
            fontSize: 10,
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
        ),
      ],
    );
  }
}
