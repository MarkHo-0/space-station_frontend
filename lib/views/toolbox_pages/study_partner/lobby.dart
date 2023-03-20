import 'dart:async';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create.dart';
import 'preview.dart';
import 'record.dart';
import '../../../api/interfaces/toolbox_api.dart';
import '../../../models/study_partner_post.dart';
import 'widgets/partner_post_item.dart';

class StudyPartnerLobbyPage extends StatefulWidget {
  const StudyPartnerLobbyPage({super.key});

  @override
  State<StudyPartnerLobbyPage> createState() => _StudyPartnerLobbyPageState();
}

class _StudyPartnerLobbyPageState extends State<StudyPartnerLobbyPage> {
  final queryTextCtl = TextEditingController();
  final scrollCtl = ScrollController();

  List<StudyPartnerPost> posts = [];
  bool loading = false;
  bool isError = false;
  String cursor = '';

  @override
  void initState() {
    super.initState();
    fetchData(isFresh: true);
    scrollCtl.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [buildViewRecordButton(context)]),
      body: RefreshIndicator(
        onRefresh: () => fetchData(isFresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                buildSearchBar(context),
                buildSubtitle(context),
                buildPosts(context),
                buildLastItem(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildViewRecordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: ((_) {
            return StudyPartnerRecordPage(onExited: (modified) {
              if (modified == true) {
                WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
              }
            });
          }),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(context.getString('my_posts')),
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: TextField(
          enabled: loading == false,
          controller: queryTextCtl,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            counterText: "",
            border: InputBorder.none,
            hintText: context.getString("partner_searchbar_hint"),
            focusedBorder: InputBorder.none,
          ),
          onSubmitted: (_) => refresh(),
        ),
      ),
    );
  }

  Widget buildSubtitle(BuildContext context) {
    late String textKey;
    if (loading == true) {
      textKey = 'loading_posts';
    } else {
      textKey = queryTextCtl.text.isEmpty ? 'recent_posts' : 'relevent_posts';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
      child: Text(
        context.getString(textKey),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget buildPosts(BuildContext context) {
    return Column(
      children: List.generate(posts.length, (index) {
        final data = posts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PartnerPostItem(data, onView: () => onViewPost(context, data)),
        );
      }).toList(),
    );
  }

  Widget buildLastItem(BuildContext context) {
    if (loading && posts.isEmpty) return const SizedBox();
    if (!loading && cursor.isNotEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Text(
            context.getString('create_post_hint'),
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: ((_) {
                  return StudyPartnerCreator(
                    oldData: null,
                    onCreated: (_) => refresh(),
                  );
                }),
              ));
            },
            child: Text(context.getString('create_post')),
          ),
        ],
      ),
    );
  }

  Future<void> refresh() => fetchData(isFresh: true);

  Future<void> fetchData({bool isFresh = false}) {
    if (loading == true) return Future.value();
    if (cursor.isEmpty && !isFresh) Future.value();
    setState(() => loading = true);
    return queryPosts(queryTextCtl.text, isFresh ? '' : cursor)
        .then((result) => onDataArrived(result, isFresh))
        .catchError((_) => isError = true)
        .whenComplete(() => setState(() => loading = false));
  }

  void onDataArrived(StudyPartnerQueryResult reuslt, bool shouldClearOld) {
    if (shouldClearOld) posts.clear();
    posts.addAll(reuslt.posts);
    cursor = reuslt.continuous;
    isError = false;
  }

  void onScroll() {}

  void onViewPost(BuildContext context, StudyPartnerPost data) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StudyPartnerPreviewer(data),
    );
  }
}
