import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../forum_create.dart';

class ForumTopPanel extends StatelessWidget {
  final void Function(int orderID) onOrderChanged;
  final void Function(String query) onSearch;

  const ForumTopPanel(
      {super.key, required this.onOrderChanged, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Row(
        children: [
          buildOrderButton(context),
          buildSearchBar(context),
          buildPostButtom(context),
        ],
      ),
    );
  }

  Widget buildOrderButton(BuildContext context) {
    bool isOrderByTime = true;
    return StatefulBuilder(builder: (BuildContext ctx, StateSetter setState) {
      return IconButton(
        onPressed: () {
          setState(() => isOrderByTime = !isOrderByTime);
          onOrderChanged(isOrderByTime ? 1 : 2);
        },
        icon: Icon(isOrderByTime ? Icons.timer_outlined : Icons.whatshot),
        tooltip: 'thread_order_${isOrderByTime ? 1 : 2}'.i18n(),
      );
    });
  }

  Widget buildSearchBar(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).splashColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: TextField(
            maxLength: 10,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              counterText: "",
              border: InputBorder.none,
              isDense: true,
              hintText: "forum_searchbar_hit_text".i18n(),
            ),
            onSubmitted: (value) => onSearch(value),
          ),
        ),
      ),
    );
  }

  Widget buildPostButtom(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => const ForumPostPage(),
        ));
      },
      icon: const Icon(Icons.edit),
      color: Theme.of(context).primaryColor,
      tooltip: 'post_thread_tooltip'.i18n(),
    );
  }
}
