import 'package:flutter/material.dart';
import 'package:space_station/utils/parse_time.dart' show unixTime2Text;

import '../../models/thread.dart';

class NewsDetail extends StatelessWidget {
  final News news;
  const NewsDetail(this.news, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Text(
                  unixTime2Text(news.publicTime),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color!.withAlpha(130),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: Text(
                  news.title,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Text(news.content),
            ],
          ),
        )
      ],
    );
  }
}

Future showNewsDetail(BuildContext context, News news) {
  return showModalBottomSheet(
    context: context,
    builder: ((context) => NewsDetail(news)),
  );
}
