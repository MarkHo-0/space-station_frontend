import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/forum_pages/thread.dart';
import 'package:space_station/views/forum_pages/widgets/post_dialog.dart';

import '../../api/interfaces/forum_api.dart';
import '../../models/comment.dart';
import '../_share/succuess_backlastpage.dart';
import 'widgets/dynamic_textbox/previewable_textfield.dart';
import 'widgets/syntax_manual.dart';
import '../../api/error.dart';
import '../_share/unknown_error_popup.dart';
import '../_share/unsave_warning_popup.dart';
import '../_styles/textfield.dart';

class ReplyPage extends StatefulWidget {
  final Comment comment;
  final int tid;
  const ReplyPage(this.comment, this.tid, {super.key});

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final contentInput = TextEditingController();
  OverlayEntry? manualContoller;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: beforeExit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.getString("reply")),
          actions: [
            IconButton(
              onPressed: () => manualContoller = showSyntaxManual(context),
              icon: const Icon(Icons.help_outline),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              header(context),
              PreviewableTextField(contentInput),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SizedBox(
              height: 45,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    border: kRoundedBorder,
                    filled: true,
                    isDense: true,
                    fillColor: Theme.of(context).splashColor,
                    hintText:
                        "Re: #${widget.comment.cid} ${widget.comment.sender.nickname}"),
                maxLines: 1,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(context.getString("reply")),
                  const Icon(
                    Icons.reply,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPressPost(BuildContext context) {
    if (contentInput.text.isEmpty) return;
    showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PostActionDialog(
        () => postComment(
          widget.tid,
          contentInput.text,
          widget.comment.cid,
        ),
      ),
    ).then((cid) {
      if (cid == null) return;
      exit(context);
    });
  }

  void exit(BuildContext context) {
    contentInput.clear();
    Navigator.of(context).pop(context);
    Future.delayed(const Duration(microseconds: 500), () {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: ((_) => ThreadPage(widget.tid)),
        ),
      );
    });
  }

  Future<bool> beforeExit() async {
    if (manualContoller != null && manualContoller!.mounted) {
      manualContoller!.remove();
      return Future.value(false);
    }

    if (contentInput.text.isEmpty) {
      return Future.value(true);
    }
    final shouldExit = await showUnsaveDialog(context);
    if (shouldExit == null) return Future.value(false);
    return Future.value(shouldExit);
  }
}
