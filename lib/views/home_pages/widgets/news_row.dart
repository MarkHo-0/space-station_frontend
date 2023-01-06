// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:space_station/views/home_pages/news_detail_popup.dart';

import '../../../models/thread.dart';
import '../../_share/titled_container.dart';

class NewsRow extends StatelessWidget {
  final List<News> newsArray;

  const NewsRow(this.newsArray, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TitledContainer(
      title: 'latest_info'.i18n(),
      body: SizedBox(
        height: 170,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 15),
          itemCount: newsArray.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return NewsCard(
              news: newsArray[index],
              onTap: (news) => showNewsDetail(context, news),
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(width: 10);
          },
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;
  final void Function(News news) onTap;

  const NewsCard({Key? key, required this.news, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      color: const Color.fromRGBO(192, 103, 103, 1),
      child: Ink(
        width: 150,
        height: 170,
        child: InkWell(
          onTap: (() => onTap(news)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              news.title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
