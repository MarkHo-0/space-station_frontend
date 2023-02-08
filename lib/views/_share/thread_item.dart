import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/thread.dart';
import 'package:space_station/views/_share/owner_tag.dart';

class ThreadItem extends StatelessWidget {
  final Thread data;
  final void Function(int threadID) onTap;
  const ThreadItem({Key? key, required this.data, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(data.tid),
      child: Ink(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withAlpha(150),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OwnerTag(
                    owner: data.sender,
                    lastUpdateTime: data.lastUpdateTime,
                  ),
                  if (data.pid == 2)
                    Text(
                      context.getString('faculty_${data.fid}'),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        height: 1,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 10),
                child: Text(
                  data.title,
                  style: const TextStyle(fontSize: 20, height: 1.2),
                ),
              ),
              ThreadItemBottom(stats: data.stats),
            ],
          ),
        ),
      ),
    );
  }
}

class ThreadItemBottom extends StatelessWidget {
  final Stats stats;
  const ThreadItemBottom({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (stats.like > 0) CouterTag(iconPath: 'up.png', count: stats.like),
        if (stats.dislike > 0)
          CouterTag(iconPath: 'down.png', count: stats.dislike),
        CouterTag(iconPath: 'msg.png', count: stats.comment),
      ],
    );
  }
}

class CouterTag extends StatelessWidget {
  final String iconPath;
  final int count;
  const CouterTag({Key? key, required this.iconPath, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/images/$iconPath',
            scale: 5,
            color: Theme.of(context).primaryColor.withOpacity(0.9),
          ),
          const SizedBox(width: 5),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
