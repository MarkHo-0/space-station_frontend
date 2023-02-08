import 'package:ez_localization/ez_localization.dart';
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
        TimeDiffText(lastUpdateTime),
      ],
    );
  }
}

// ignore: must_be_immutable
class TimeDiffText extends StatelessWidget {
  final int time;
  late String Function(String key, [dynamic args]) _lang;
  late int diffInUnix;

  TimeDiffText(this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    _lang = context.getString;
    return Text(
      parseTime(),
      style: const TextStyle(
        color: Color.fromRGBO(116, 116, 116, 1),
        fontSize: 10,
      ),
      strutStyle: const StrutStyle(
        forceStrutHeight: true,
        height: 1,
      ),
    );
  }

  String parseTime() {
    diffInUnix = getCurrUnixTime() - time;
    if (diffInUnix < 0) return _lang('time_future');
    if (diffInUnix < 10) return _lang('time_just_now');

    if (diffInUnix <= kOneMinute) return _lang('time_second', toArg(1));
    if (diffInUnix <= kOneHour) return _lang('time_minute', toArg(kOneMinute));
    if (diffInUnix <= kOneDay) return _lang('time_hour', toArg(kOneHour));
    if (diffInUnix <= kOneMonth) return _lang('time_day', toArg(kOneDay));
    if (diffInUnix <= kOneYear) return _lang('time_month', toArg(kOneMonth));

    return _lang('time_year', toArg(kOneYear));
  }

  dynamic toArg(int divider) {
    return {'s': (diffInUnix / divider).floor()};
  }
}
