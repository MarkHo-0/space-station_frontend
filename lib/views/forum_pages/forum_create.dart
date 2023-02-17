import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/thread.dart';
import 'package:space_station/views/forum_pages/widgets/category_selector.dart';
import 'package:space_station/views/forum_pages/widgets/multi_tabs_thread_list.dart';
import './widgets/forum_top_panel.dart';
import 'package:ez_localization/ez_localization.dart';
import '../../api/interfaces/forum_api.dart';

class ForumPostPage extends StatefulWidget {
  const ForumPostPage({super.key});

  @override
  State<ForumPostPage> createState() => _ForumPostPageState();
}

class _ForumPostPageState extends State<ForumPostPage> {
  int categoryID = 0;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text(context.getString("create_post")),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [Switch(value: true, onChanged: ((value) {}))],
        ),
        body: Column(children: [
          Container(
              padding: const EdgeInsets.only(top: 15),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CategorySelector(
                    categoryKey: "faculty",
                    quantity: 6,
                    categoryID: categoryID,
                    onChanged: ((categoryID) {
                      this.categoryID = categoryID;
                      setState(() {});
                    }),
                  ),
                ),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      icon: Transform.rotate(
                        angle: -3.1415926,
                        child: const Icon(Icons.send),
                      ),
                      label: Text(context.getString("send_thread")),
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ))
              ])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SizedBox(
              // <--- SizedBox
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title...',
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: MediaQuery.of(context).size.height - 300,
            child: Expanded(
              child: TextField(
                maxLines: null,
                minLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter...',
                ),
              ),
            ),
          )
        ]));
  }

  String regecx(TextEditingController body) {
    Text(body.text);
    return "";
  }
}
