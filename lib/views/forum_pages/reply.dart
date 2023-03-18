import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import '../../models/comment.dart';
import 'widgets/dynamic_textbox/previewable_textfield.dart';
import 'widgets/syntax_manual.dart';
import '../_share/unsave_warning_popup.dart';

class ReplyPage extends StatefulWidget {
  final Comment? replyTo;
  final int? cIndex;
  final Future<bool> Function(String) postRunner;
  const ReplyPage(this.postRunner, this.replyTo, this.cIndex, {super.key});

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
    String rTitle = '';
    if (widget.cIndex != null && widget.replyTo != null) {
      rTitle = "Re: #${widget.cIndex! + 1} ${widget.replyTo!.sender.nickname}";
    }
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
                  rTitle,
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
    widget.postRunner(contentInput.text).then((successed) {
      Navigator.of(dialogCtx).pop();
      if (successed) Navigator.of(pageCtx).pop();
    });
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
