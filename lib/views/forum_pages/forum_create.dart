import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:space_station/views/forum_pages/widgets/page_dropdown.dart';
import 'dart:developer';

import '../_styles/textfield.dart';

class ForumPostPage extends StatefulWidget {
  const ForumPostPage({super.key});

  @override
  State<ForumPostPage> createState() => _ForumPostPageState();
}

class _ForumPostPageState extends State<ForumPostPage> {
  bool isPreview = false;
  String mode = "create_post";
  Widget bodywidget = const ScaffoldBody(); // changeable body widget
  @override
  Widget build(BuildContext context) {
    Text appbarText = Text(context.getString(mode)); //changeble appbar title
    return Scaffold(
      appBar: AppBar(
        title: appbarText,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Switch(
            value: isPreview,
            onChanged: ((value) {
              setState(() {
                isPreview = value;
                if (value == true) {
                  mode = "preview_mode";
                  bodywidget = const ScaffoldPreViewBody();
                }
                if (value == false) {
                  mode = "create_post";
                  bodywidget = const ScaffoldBody();
                }
              });
            }),
          ),
        ],
      ),
      body: bodywidget,
    );
  }
}

class ScaffoldBody extends StatefulWidget {
  const ScaffoldBody({super.key});

  @override
  State<ScaffoldBody> createState() => _ScaffoldBodyState();
}

class _ScaffoldBodyState extends State<ScaffoldBody> {
  int selectedPageID = 0;
  int selectedCategoryID = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
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

////////////////////////////////////////////
////////////////////////////////////////////

class ScaffoldPreViewBody extends StatefulWidget {
  const ScaffoldPreViewBody({super.key});

  @override
  State<ScaffoldPreViewBody> createState() => _ScaffoldPreViewBodyState();
}

class _ScaffoldPreViewBodyState extends State<ScaffoldPreViewBody> {
  @override
  Widget build(BuildContext context) {
    return const Text("123");
    /////////
    ///////// not finished
  }
}
