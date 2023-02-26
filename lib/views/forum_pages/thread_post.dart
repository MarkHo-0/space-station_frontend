import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:space_station/views/forum_pages/thread.dart';

import '../../api/interfaces/forum_api.dart';
import 'widgets/post_dialog.dart';
import 'widgets/dynamic_textbox/dynamic_textbox.dart';
import 'widgets/page_dropdown.dart';
import '../_styles/textfield.dart';

class ThreadPostPage extends StatefulWidget {
  const ThreadPostPage({super.key});

  @override
  State<ThreadPostPage> createState() => _ThreadPostPageState();
}

class _ThreadPostPageState extends State<ThreadPostPage> {
  final titleInput = TextEditingController();
  final contentInput = TextEditingController();
  final destDropdown = PageDropdownController();
  bool isPreview = false;
  bool canPost = false;

  @override
  void initState() {
    super.initState();
    titleInput.addListener(checkCanPost);
    contentInput.addListener(checkCanPost);
    destDropdown.addListener(checkCanPost);
  }

  @override
  Widget build(BuildContext context) {
    //changeble appbar title
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getString('create_thread')),
        actions: [
          Visibility(
            visible: canPost,
            child: TextButton(
              onPressed: (() => setState(() => isPreview = !isPreview)),
              child: Text(
                context.getString(isPreview ? "edit_action" : "preview_action"),
              ),
            ),
          ),
        ],
      ),
      body: isPreview
          ? BodyPreviewPage(contentInput)
          : InputForm(titleInput, contentInput, destDropdown, canPost),
    );
  }

  void checkCanPost() {
    if (titleInput.text.trim().isEmpty ||
        contentInput.text.trim().isEmpty ||
        destDropdown.isEmpty) {
      if (canPost == true) setState(() => canPost = false);
    } else {
      if (canPost == false) setState(() => canPost = true);
    }
  }
}

class InputForm extends StatelessWidget {
  final TextEditingController titleInput;
  final TextEditingController contentInput;
  final PageDropdownController destDropdown;
  final bool canPost;

  const InputForm(
    this.titleInput,
    this.contentInput,
    this.destDropdown,
    this.canPost, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageDropdown(controller: destDropdown),
                Visibility(
                  visible: canPost,
                  child: Padding(
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
                  ),
                )
              ],
            ),
          ),
          Padding(
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
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              controller: contentInput,
              keyboardType: TextInputType.multiline,
              autocorrect: false,
              decoration: InputDecoration(
                border: kRoundedBorder,
                focusedBorder: kRoundedBorder,
                filled: true,
                fillColor: Theme.of(context).splashColor,
                contentPadding: kContentPadding,
                hintText: context.getString("content_hint"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPressedPost(BuildContext context) {
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
      if (threadID >= 0) Navigator.pop(context);
      if (threadID > 0) {
        Future.delayed(const Duration(microseconds: 500), () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: ((_) => ThreadPage(threadID)),
            ),
          );
        });
      }
    });
  }
}

class BodyPreviewPage extends StatelessWidget {
  final TextEditingController contentInput;
  const BodyPreviewPage(this.contentInput, {super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicTextBox(contentInput.text);
  }
}
