import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_toast/m_toast.dart';
import '../../../models/comment.dart';
import '../../_share/owner_tag.dart';
import '../../../providers/auth_provider.dart';
import '../../_share/banned_message.dart';
import '../../_styles/padding.dart';
import 'dynamic_textbox/dynamic_textbox.dart';
import '../../../api/interfaces/forum_api.dart';
import '../../_share/unknown_error_popup.dart';
import '../report.dart';
import 'pinned_badge.dart';

class CommentContiner extends StatelessWidget {
  final int floorIndex;
  final Comment comment;
  final ValueNotifier<int?> currentPinned;
  final bool isOwnedParentThread;
  final void Function(BuildContext, int) onPin;
  final void Function(BuildContext, int?, Function?) onReply;

  const CommentContiner({
    super.key,
    required this.comment,
    required this.currentPinned,
    required this.floorIndex,
    required this.isOwnedParentThread,
    required this.onPin,
    required this.onReply,
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
            buildContentContainer(context),
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
              "#${floorIndex + 1}",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 5),
            OwnerTag(owner: comment.sender, lastUpdateTime: comment.createTime)
          ],
        ),
        Row(
          children: [
            PinnedBadge(comment.cid, currentPinned, isOwnedParentThread),
            buildMoreButton(context),
          ],
        )
      ],
    );
  }

  Widget buildContentContainer(BuildContext context) {
    if (comment.status == 2) return bannedBody(context);
    if (comment.status == 1) return problematicBody(context);
    return defaultBody(context);
  }

  Widget defaultBody(BuildContext context) {
    return Column(
      children: [
        if (comment.replyto != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              color: Theme.of(context).hoverColor,
              child: DynamicTextBox(comment.replyto!.content),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: DynamicTextBox(comment.content),
        ),
        buildFooter(context),
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

  Widget buildMoreButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        if (isOwnedParentThread == true)
          PopupMenuItem(
            value: 0,
            child: ListTile(
              dense: true,
              leading: const Icon(
                Icons.star_border_sharp,
                color: Colors.orangeAccent,
              ),
              title: Text(context.getString("pin_comment")),
              onTap: () => onPin(context, comment.cid),
            ),
          ),
        PopupMenuItem(
          value: 1,
          child: ListTile(
            dense: true,
            leading: const Icon(
              Icons.report,
              color: Colors.redAccent,
            ),
            title: Text(context.getString("report")),
            onTap: () => report(context),
          ),
        ),
      ],
      offset: const Offset(0, 20),
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).hintColor,
        size: 20,
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildReactionButtons(),
        buildReplyButton(context),
      ],
    );
  }

  Widget buildReactionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          final rt = comment.stats.me;
          return Row(
            children: [
              TextButton.icon(
                onPressed: () => react(context, 1, () => setState(() {})),
                icon: Icon(
                  rt == 1 ? Icons.thumb_up_alt : Icons.thumb_up_off_alt,
                ),
                label: Text(comment.stats.like.toString()),
                style: noPaddingTextButtonStyle,
              ),
              const SizedBox(width: 15),
              TextButton.icon(
                onPressed: () => react(context, 2, () => setState(() {})),
                icon: Icon(
                  rt == 2 ? Icons.thumb_down_alt : Icons.thumb_down_off_alt,
                ),
                label: Text(comment.stats.dislike.toString()),
                style: noPaddingTextButtonStyle,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildReplyButton(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: TextButton.icon(
            icon: const Icon(Icons.comment),
            style: noPaddingTextButtonStyle,
            label: Visibility(
              visible: comment.stats.reply > 0,
              child: Text(comment.stats.reply.toString()),
            ),
            onPressed: () => reply(context, () => setState(() {})),
          ),
        );
      },
    );
  }

  void react(BuildContext context, int reactionType, Function updateUI) {
    if (getLoginedUser(context, warnOnEmpty: true) == null) return;
    reactComment(comment.cid, reactionType)
        .then((newReation) => handleNewReaction(newReation))
        .then((value) => updateUI())
        .onError((_, __) => showUnkownErrorDialog(context));
  }

  void reply(BuildContext context, Function refreshCount) {
    onReply(context, floorIndex, () {
      comment.stats.reply++;
      refreshCount();
    });
  }

  void report(BuildContext context) {
    if (getLoginedUser(context, warnOnEmpty: true) == null) return;
    if (comment.status == 2) return showBannedMessageDialog(context);
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: ((_) {
          return ReportPage(
            comment: comment,
            floorIndex: floorIndex,
            onReportSuccessed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ShowMToast().successToast(
                  context,
                  message: context.getString("report_success_message"),
                  alignment: Alignment.bottomCenter,
                  duration: 3000,
                );
              });
            },
          );
        }),
      ),
    );
  }

  void handleNewReaction(int newReation) {
    if (newReation == comment.stats.me) return;

    if (newReation == 0) {
      if (comment.stats.me == 1) {
        comment.stats.like -= 1;
      } else {
        comment.stats.dislike -= 1;
      }
    }

    if (newReation == 1) {
      if (comment.stats.me == 0) {
        comment.stats.like += 1;
      } else {
        comment.stats.dislike -= 1;
        comment.stats.like += 1;
      }
    }

    if (newReation == 2) {
      if (comment.stats.me == 0) {
        comment.stats.dislike += 1;
      } else {
        comment.stats.like -= 1;
        comment.stats.dislike += 1;
      }
    }

    comment.stats.me = newReation;
  }
}
