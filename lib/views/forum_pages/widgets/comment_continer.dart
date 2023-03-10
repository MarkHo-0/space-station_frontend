import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/models/comment.dart';
import 'package:space_station/views/_share/owner_tag.dart';
import 'package:space_station/views/forum_pages/report.dart';
import '../../../providers/auth_provider.dart';
import '../../_share/banned_message.dart';
import '../../_styles/padding.dart';
import '../reply.dart';
import 'dynamic_textbox/dynamic_textbox.dart';
import '../../../api/error.dart';
import '../../../api/interfaces/forum_api.dart';
import '../../../models/thread.dart';
import '../../_share/need_login_popup.dart';
import '../../_share/unknown_error_popup.dart';

class CommentContiner extends StatelessWidget {
  final Comment comment;
  final Thread thread;
  final int index;

  const CommentContiner({
    super.key,
    required this.comment,
    required this.thread,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withAlpha(150),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            buildHeader(context),
            buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "#${index + 1}",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 5),
            OwnerTag(owner: comment.sender, lastUpdateTime: comment.createTime)
          ],
        ),
        Row(
          children: [
            Visibility(
              visible: thread.pinedCid == comment.cid,
              child: Text(
                context.getString("comment_pinned"),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            popupbutton(context),
          ],
        )
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    if (comment.status == 2) return bannedBody(context);
    if (comment.status == 1) return problematicBody(context);
    return defaultBody(context);
  }

  Widget defaultBody(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: comment.replyto != null,
          child: Text(
            ">> #${comment.cid} ${comment.replyto?.sender.nickname}",
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: DynamicTextBox(comment.content),
        ),
        CommentFooter(comment, thread.tid, comment.stats),
      ],
    );
  }

  Widget problematicBody(BuildContext buildContext) {
    bool isHiding = false;
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        if (isHiding) return defaultBody(context);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                context.getString("content_warning_hint"),
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () => setState(() => isHiding = true),
                child: Text(context.getString("content_warning_show")),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bannedBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        context.getString("content_violation_hint"),
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }

  Widget popupbutton(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return PopupMenuButton(
      itemBuilder: (context) => [
        if (getUid(context, auth) == thread.sender.uid) popUpPinItem(context),
        PopupMenuItem(
          onTap: () => onReportPage(context, comment),
          child: Row(
            children: [
              const Icon(Icons.report),
              Text(context.getString("report")),
            ],
          ),
        )
      ],
      offset: const Offset(0, 20),
      elevation: 2,
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).hintColor,
        size: 20,
      ),
    );
  }

  PopupMenuItem<int> popUpPinItem(BuildContext context) {
    return PopupMenuItem(
      child: Row(
        children: [
          const Icon(Icons.star_border_sharp),
          Text(context.getString("pin_comment")),
        ],
      ),
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {});
      },
    );
  }

  int? getUid(BuildContext context, AuthProvider auth) {
    if (auth.isLogined) return auth.user!.uid;
    return null;
  }

  void onReportPage(BuildContext context, Comment comment) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.isLogined == false) return showNeedLoginDialog(context);
      if (comment.status == 2) return showBannedMessageDialog(context);
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: ((_) => ReportPage(comment)),
        ),
      );
    });
  }
}

class CommentFooter extends StatefulWidget {
  final Comment comment;
  final int threadID;
  final CommentStats stats;
  const CommentFooter(this.comment, this.threadID, this.stats, {super.key});

  @override
  State<CommentFooter> createState() => _CommentFooterState();
}

class _CommentFooterState extends State<CommentFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        reactionButtons(context),
        commentButton(context),
      ],
    );
  }

  Widget reactionButtons(BuildContext context) {
    final rt = widget.stats.me;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => onReact(context, 1),
            icon: Icon(rt == 1 ? Icons.thumb_up_alt : Icons.thumb_up_off_alt),
            label: Text(widget.stats.like.toString()),
            style: noPaddingTextButtonStyle,
          ),
          const SizedBox(width: 15),
          TextButton.icon(
            onPressed: () => onReact(context, 2),
            icon:
                Icon(rt == 2 ? Icons.thumb_down_alt : Icons.thumb_down_off_alt),
            label: Text(widget.stats.dislike.toString()),
            style: noPaddingTextButtonStyle,
          ),
        ],
      ),
    );
  }

  void updatebutton(int finalReation) {
    if (finalReation == widget.stats.me) return;

    if (finalReation == 0) {
      if (widget.stats.me == 1) {
        widget.stats.like -= 1;
      } else {
        widget.stats.dislike -= 1;
      }
    }

    if (finalReation == 1) {
      if (widget.stats.me == 0) {
        widget.stats.like += 1;
      } else {
        widget.stats.dislike -= 1;
        widget.stats.like += 1;
      }
    }

    if (finalReation == 2) {
      if (widget.stats.me == 0) {
        widget.stats.dislike += 1;
      } else {
        widget.stats.like -= 1;
        widget.stats.dislike += 1;
      }
    }

    widget.stats.me = finalReation;
    setState(() {});
  }

  void onReact(BuildContext context, int reactionType) {
    reactComment(widget.comment.cid, reactionType)
        .then((value) => updatebutton(value))
        .catchError((_) => showNeedLoginDialog(context),
            test: (e) => e is AuthorizationError)
        .onError((_, __) => showUnkownErrorDialog(context));
  }

  Widget commentButton(BuildContext context) {
    final shouldShow = widget.stats.reply > 0;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        onPressed: () =>
            onReplyPage(context, widget.threadID, widget.comment.cid),
        icon: const Icon(Icons.comment),
        label:
            shouldShow ? Text(widget.stats.reply.toString()) : const SizedBox(),
        style: noPaddingTextButtonStyle,
      ),
    );
  }

  void onReplyPage(BuildContext context, int tid, int cid) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.isLogined == false) return showNeedLoginDialog(context);
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: ((_) => ReplyPage(widget.comment, cid)),
      ),
    );
  }
}
