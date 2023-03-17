import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import '../../models/comment.dart';
import 'widgets/dynamic_textbox/previewable_textfield.dart';
import 'widgets/syntax_manual.dart';
import '../_share/unsave_warning_popup.dart';
import '../_share/unknown_error_popup.dart';

class ReplyPage extends StatefulWidget {
  final Comment? replyTo;
  final int? cIndex;
  final Future<void> Function(String) onPost;
  const ReplyPage(this.replyTo, this.cIndex, this.onPost, {super.key});

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
                  "Re: #${widget.cIndex! + 1} ${widget.replyTo!.sender.nickname}",
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
              onPressed: () => showConfirmationDialog(context),
              label: Text(context.getString("reply")),
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmationDialog(BuildContext pageCtx) {
    if (contentInput.text.isEmpty) return;
    showDialog<int?>(
      context: pageCtx,
      builder: (dialogCtx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        content: Text(
          pageCtx.getString("before_post_confirm"),
          style: Theme.of(pageCtx).textTheme.titleMedium!,
        ),
        actions: [
          TextButton(
            onPressed: () => performPost(dialogCtx, pageCtx),
            child: Text(pageCtx.getString("conform")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, null),
            child: Text(
              pageCtx.getString("cancel"),
              style: TextStyle(color: Theme.of(pageCtx).disabledColor),
            ),
          ),
        ],
      ),
    );
  }

  void performPost(BuildContext dialogCtx, BuildContext pageCtx) {
    widget.onPost(contentInput.text).then<void>((_) {
      Navigator.of(dialogCtx).pop();
      Navigator.of(pageCtx).pop();
    }).catchError((_) => showUnkownErrorDialog(pageCtx));
  }

  Future<bool> beforeExit() async {
    if (manualContoller != null && manualContoller!.mounted) {
      manualContoller!.remove();
      return false;
    }

    if (contentInput.text.isEmpty) {
      return true;
    }
    final shouldExit = await showUnsaveDialog(context);
    if (shouldExit == null) return Future.value(false);
    return shouldExit;
  }
}
