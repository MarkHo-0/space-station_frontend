import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ez_localization/ez_localization.dart';

import 'widgets/dynamic_textbox/dynamic_textbox.dart';
import 'widgets/page_dropdown.dart';
import '../_styles/textfield.dart';

class ForumPostPage extends StatefulWidget {
  const ForumPostPage({super.key});

  @override
  State<ForumPostPage> createState() => _ForumPostPageState();
}

class _ForumPostPageState extends State<ForumPostPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isPreview = false;
  @override
  Widget build(BuildContext context) {
    //changeble appbar title
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.getString(isPreview ? 'preview_mode' : 'create_post'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Switch(
            value: isPreview,
            onChanged: ((value) {
              setState(() => isPreview = value);
            }),
          ),
        ],
      ),
      body: isPreview
          ? BodyPreviewPage(bodyController)
          : InputForm(titleController, bodyController),
    );
  }
}

// ignore: must_be_immutable
class InputForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  InputForm(
    this.titleController,
    this.bodyController, {
    super.key,
  });

  int selectedPageID = 0;
  int selectedCategoryID = 0;

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
                PageDropdown(
                  onChanged: (pageID, categoryID) {
                    selectedPageID = pageID;
                    selectedCategoryID = categoryID;
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Row(
                    children: [
                      Text(context.getString("post_action")),
                      const SizedBox(width: 5),
                      const Icon(Icons.send, size: 20),
                    ],
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                border: kRoundedBorder,
                focusedBorder: kRoundedBorder,
                filled: true,
                fillColor: Theme.of(context).splashColor,
                contentPadding: kContentPadding,
                hintText: context.getString("thread_title_hint"),
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              maxLines: 1,
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              minLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              controller: bodyController,
              keyboardType: TextInputType.multiline,
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
}

class BodyPreviewPage extends StatelessWidget {
  final TextEditingController bodyController;
  const BodyPreviewPage(this.bodyController, {super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicTextBox(bodyController.text);
  }
}
