import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/study_partner_post.dart';
import 'package:space_station/views/_share/before_remove_popup.dart';
import 'package:space_station/views/_share/loading_page.dart';
import 'package:space_station/views/_share/network_error_page.dart';
import 'package:space_station/views/toolbox_pages/study_partner/widgets/partner_post_item.dart';

import '../../_share/unknown_error_popup.dart';
import 'create.dart';

class StudyPartnerRecordPage extends StatefulWidget {
  final void Function(bool modified) onExited;
  const StudyPartnerRecordPage({required this.onExited, super.key});

  @override
  State<StudyPartnerRecordPage> createState() => _StudyPartnerRecordPageState();
}

class _StudyPartnerRecordPageState extends State<StudyPartnerRecordPage> {
  bool isModified = false;
  bool loading = false;
  bool isError = false;
  List<StudyPartnerPost> records = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getString('my_posts')),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    if (loading && records.isEmpty) return const LoadingPage();
    if (isError) return const NetworkErrorPage();
    if (records.isEmpty) return buildEmptyBody(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
      child: Column(
        children: List.generate(records.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PartnerPostItem(
              records[index],
              onEdit: () => onEditPost(context, index),
              onRemove: () => onRemovePost(context, index),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildEmptyBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.getString('no_posts_hint'),
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
                    onCreated: (_) => fetchData(),
                  );
                }),
              ));
            },
            child: Text(context.getString('create_recruitment')),
          ),
        ],
      ),
    );
  }

  void onEditPost(BuildContext context, int index) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: ((_) {
        return StudyPartnerCreator(
          oldData: records[index],
          onCreated: (data) {
            records[index] = data;
            isModified = true;
            setState(() {});
          },
        );
      })),
    );
  }

  void onRemovePost(BuildContext context, int index) {
    showRemoveConfirmation(context, () {
      removePost(records[index]).then((_) {
        records.removeAt(index);
        isModified = true;
        setState(() {});
        return null;
      }).catchError((_) {
        showUnkownErrorDialog(context);
      });
    });
  }

  Future<void> fetchData() {
    if (loading == true) return Future.value();
    setState(() => loading = true);
    return getPostRecords()
        .then((records) => onDataArrived(records))
        .catchError((_) => isError = true)
        .whenComplete(() => setState(() => loading = false));
  }

  void onDataArrived(List<StudyPartnerPost> data) {
    records = data;
    isError = false;
  }

  @override
  void dispose() {
    widget.onExited(isModified);
    super.dispose();
  }
}
