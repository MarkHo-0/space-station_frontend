import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ez_localization/ez_localization.dart';

import 'widgets/dynamic_textbox/previewable_textfield.dart';
import 'widgets/syntax_manual.dart';
import 'widgets/post_dialog.dart';
import 'widgets/page_dropdown.dart';
import 'thread.dart';
import '../_share/unsave_warning_popup.dart';
import '../../api/interfaces/forum_api.dart';
import '../_styles/textfield.dart';

class ThreadPostPage extends StatefulWidget {
  final void Function(int) onPosted;
  const ThreadPostPage({super.key, required this.onPosted});
  @override
  State<ThreadPostPage> createState() => _ThreadPostPageState();
}

class _ThreadPostPageState extends State<ThreadPostPage> {
  final titleInput = TextEditingController();
  final contentInput = TextEditingController();
  final destDropdown = PageDropdownController();
  OverlayEntry? manualContoller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: beforeExit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.getString('create_thread')),
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
              buildPageSelectorAndButtom(context),
              buildTitleInput(context),
              PreviewableTextField(contentInput),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageSelectorAndButtom(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageDropdown(controller: destDropdown),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () => onPressedPost(context),
              child: Row(
                children: [
                  Text(context.getString("post_action")),
                  const SizedBox(width: 5),
                  const Icon(Icons.send, size: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTitleInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        autofocus: true,
        controller: titleInput,
        decoration: InputDecoration(
          border: kRoundedBorder,
          focusedBorder: kRoundedBorder,
          filled: true,
          fillColor: Theme.of(context).splashColor,
          contentPadding: kContentPadding,
          hintText: context.getString("thread_title_hint"),
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        textInputAction: TextInputAction.next,
        maxLines: 1,
      ),
    );
  }

  Future<bool> beforeExit() async {
    if (manualContoller != null && manualContoller!.mounted) {
      manualContoller!.remove();
      return Future.value(false);
    }

    if (titleInput.text.isEmpty &&
        contentInput.text.isEmpty &&
        destDropdown.isEmpty) {
      return Future.value(true);
    }
    final shouldExit = await showUnsaveDialog(context);
    if (shouldExit == null) return Future.value(false);
    return Future.value(shouldExit);
  }

  void onPressedPost(BuildContext context) {
    bool canPost = titleInput.text.trim().isNotEmpty &&
        contentInput.text.trim().isNotEmpty &&
        destDropdown.isEmpty == false;
    if (canPost == false) return;

    showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PostActionDialog(
        () => postThread(
          destDropdown.pageID,
          destDropdown.categoryID,
          titleInput.text,
          contentInput.text,
        ),
      ),
    ).then((threadID) {
      if (threadID == null) return;
      widget.onPosted(destDropdown.pageID);

      destDropdown.clear();
      titleInput.clear();
      contentInput.clear();
      if (threadID == 0) return Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: ((_) => ThreadPage(threadID)),
        ),
      );
    });
  }
}
