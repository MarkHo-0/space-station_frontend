import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/utils/parse_time.dart';
import 'package:space_station/views/_share/unknown_error_popup.dart';
import '../../api/interfaces/forum_api.dart';
import '../../models/comment.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import 'widgets/dynamic_textbox/previewable_textfield.dart';
import 'widgets/syntax_manual.dart';
import '../_share/unsave_warning_popup.dart';

class ReplyPage extends StatefulWidget {
  final Comment? comment;
  final int? commentIndex;
  final int threadID;
  final void Function(Comment reply) onSuccess;
  const ReplyPage(
      this.comment, this.threadID, this.commentIndex, this.onSuccess,
      {super.key});

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
              buildHeader(context),
              const SizedBox(height: 10),
              PreviewableTextField(contentInput),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).splashColor,
                borderRadius: BorderRadius.circular(3),
              ),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Re: #${widget.commentIndex! + 1} ${widget.comment!.sender.nickname}",
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.reply),
              onPressed: () => onPressPost(context),
              label: Text(context.getString("reply")),
            ),
          ),
        ],
      ),
    );
  }

  void onPressPost(BuildContext context) {
    if (contentInput.text.isEmpty) return;
    showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (dContext) => Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dContext.getString("before_post_confirm"),
                style: Theme.of(dContext).textTheme.titleMedium!,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: () {
                      postComment(
                        widget.threadID,
                        contentInput.text,
                        widget.comment?.cid,
                      )
                          .then((replyID) => Navigator.pop(dContext, replyID))
                          .catchError((_, __) => Navigator.pop(dContext, -1));
                    },
                    child: Text(dContext.getString("conform")),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dContext, null),
                    child: Text(
                      dContext.getString("cancel"),
                      style: TextStyle(color: Theme.of(dContext).disabledColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((replyID) {
      if (replyID == null) return;
      if (replyID < 0) return showUnkownErrorDialog(context);
      final user = Provider.of<AuthProvider>(context, listen: false).user!;
      final reply = Comment(
        cid: replyID,
        content: contentInput.text,
        createTime: getCurrUnixTime(),
        replyto: widget.comment,
        stats: CommentStats(like: 0, dislike: 0, reply: 0, me: 0),
        sender: User.fromInfo(user),
        status: 0,
      );
      contentInput.clear();
      widget.onSuccess(reply);
      Navigator.of(context).pop();
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
