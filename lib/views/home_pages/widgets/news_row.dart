// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../models/thread.dart';
import '../../_share/titled_container.dart';

class NewsRow extends StatelessWidget {
  final List<News> data;

  const NewsRow(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TitledContainer(
      title: 'latest_info'.i18n(),
      body: SizedBox(
        height: 170,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 15),
          itemCount: data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return NewsCard(data: data[index]);
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
  final News data;

  const NewsCard({Key? key, required this.data}) : super(key: key);

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
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              data.title,
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
