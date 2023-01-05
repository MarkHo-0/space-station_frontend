// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

import 'package:space_station/models/thread.dart';
import 'package:space_station/utils/parse_time.dart';

class ThreadItem extends StatelessWidget {
  final Thread data;
  const ThreadItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color.fromRGBO(188, 188, 188, 1), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Column(
            children: [
              //username   day
              Container(
                height: 24,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      data.sender.nickname,
                      style: const TextStyle(
                        color: Color.fromRGBO(110, 127, 183, 1),
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      unixTime2String(data.lastUpdateTime),
                      style: const TextStyle(
                        color: Color.fromRGBO(116, 116, 116, 1),
                        fontSize: 10,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              //title
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              // menus
              ThreadItemBottom(data: data.stats)
            ],
          ),
        ),
      ),
    );
  }
}

class ThreadItemBottom extends StatelessWidget {
  final Stats data;
  const ThreadItemBottom({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (data.like > 0) CouterTag(iconPath: 'up.png', count: data.like),
        if (data.dislike > 0) CouterTag(iconPath: 'down.png', count: data.dislike),
        CouterTag(iconPath: 'msg.png', count: data.comment),
      ],
    );
  }
}

class CouterTag extends StatelessWidget {
  final String iconPath;
  final int count;
  const CouterTag({Key? key, required this.iconPath, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Image.asset('assets/images/$iconPath', width: 10, height: 11),
          const SizedBox(width: 3),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(110, 127, 183, 1),
            ),
          ),
        ],
      ),
    );
  }
}
