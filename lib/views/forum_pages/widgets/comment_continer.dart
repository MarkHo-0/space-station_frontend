import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/comment.dart';
import 'package:space_station/views/_share/owner_tag.dart';
import 'dynamic_textbox/dynamic_textbox.dart';
import '../../../api/error.dart';
import '../../../api/interfaces/forum_api.dart';
import '../../../models/thread.dart';
import '../../_share/need_login_popup.dart';
import '../../_share/unknown_error_popup.dart';

class CommentContiner extends StatefulWidget {
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
  State<CommentContiner> createState() => _CommentContinerState();
}

class _CommentContinerState extends State<CommentContiner> {
  bool isShowComment = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withAlpha(150),
              ),
            ),
          ),
          child: Column(
            children: [
              upperRow(context, widget.comment, widget.thread),
              body(context, widget.comment, widget.thread)
            ],
          ),
        ),
      ],
    );
  }

  Widget upperRow(BuildContext context, Comment currentcomment, Thread thread) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "#${widget.index + 1}",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 10),
            OwnerTag(
              owner: currentcomment.sender,
              lastUpdateTime: currentcomment.createTime,
            )
          ],
        ),
        Row(
          children: [
            if (thread.pinedCid == currentcomment.cid)
              Text(context.getString("best_relpy")),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            )
          ],
        )
      ],
    );
  }

  Widget body(BuildContext context, Comment currentcomment, Thread thread) {
    if (currentcomment.status == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
        child: Text(
          context.getString("violation_message"),
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
      );
    }
    if (currentcomment.status == 1 && isShowComment == false) {
      return _warningbody(context, currentcomment, thread);
    }
    return _body(context, currentcomment, thread);
  }

  Widget _body(BuildContext context, Comment currentcomment, Thread thread) {
    return Column(children: [
      if (currentcomment.replyto != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(">>${currentcomment.replyto?.cid}"),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: DynamicTextBox(currentcomment.content),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        buttonRow(context, currentcomment),
        commentRow(context, currentcomment)
      ])
    ]);
  }

  Widget _warningbody(
      BuildContext context, Comment currentcomment, Thread thread) {
    Widget warningbody = Column(children: [
      Text(
        context.getString("warning_message"),
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      TextButton(
          style: TextButton.styleFrom(
              textStyle: const TextStyle(
            decoration: TextDecoration.underline,
          )),
          onPressed: () {
            setState(() => isShowComment = true);
          },
          child: Text(context.getString("warning_viewcomment"))),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        buttonRow(context, currentcomment),
        commentRow(context, currentcomment)
      ])
    ]);
    return warningbody;
  }

  Widget buttonRow(BuildContext context, Comment currentcomment) {
    final Icon likeIcon = currentcomment.stats.me == 1
        ? const Icon(Icons.thumb_up_alt)
        : const Icon(Icons.thumb_up_off_alt);
    final Icon dislikeIcon = currentcomment.stats.me == 2
        ? const Icon(Icons.thumb_down_alt)
        : const Icon(Icons.thumb_down_off_alt);

    return Row(
      children: [
        Row(children: [
          TextButton.icon(
              onPressed: () => pressbutton(context, currentcomment.cid, 1),
              icon: likeIcon,
              label: Text(currentcomment.stats.like.toString()))
        ]),
        Row(
          children: [
            TextButton.icon(
                onPressed: () => pressbutton(context, currentcomment.cid, 2),
                icon: dislikeIcon,
                label: Text(currentcomment.stats.dislike.toString()))
          ],
        )
      ],
    );
  }

  void updatebutton(int finalreation) {
    if (finalreation == widget.comment.stats.me) return;
    setState(() {
      if (finalreation == 0) {
        if (widget.comment.stats.me == 1) {
          widget.comment.stats.like -= 1;
        } else {
          widget.comment.stats.dislike -= 1;
        }
      }

      if (finalreation == 1) {
        if (widget.comment.stats.me == 0) {
          widget.comment.stats.like += 1;
        } else {
          widget.comment.stats.dislike -= 1;
          widget.comment.stats.like += 1;
        }
      }

      if (finalreation == 2) {
        if (widget.comment.stats.me == 0) {
          widget.comment.stats.dislike += 1;
        } else {
          widget.comment.stats.like -= 1;
          widget.comment.stats.dislike += 1;
        }
      }

      widget.comment.stats.me = finalreation;
    });
  }

  void pressbutton(BuildContext context, int cid, int newme) {
    reactComment(cid, newme)
        .then((value) => updatebutton(value))
        .catchError((_) => showNeedLoginDialog(context),
            test: (e) => e is AuthorizationError)
        .onError((_, __) => showUnkownErrorDialog(context));
  }

  Widget commentRow(BuildContext context, Comment currentcomment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Row(
        children: [
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.comment),
              label: Text(currentcomment.stats.reply.toString()))
        ],
      ),
    );
  }
}
