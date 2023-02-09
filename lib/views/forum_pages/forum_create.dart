import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/thread.dart';
import 'widgets/multi_tabs_thread_list.dart';
import './widgets/forum_top_panel.dart';
import '../../api/interfaces/forum_api.dart';

class ForumPostPage extends StatelessWidget {
  const ForumPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    const height = 200.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: SizedBox(
          // <--- SizedBox
          height: height,
          child: TextField(
            maxLines: height ~/ 10, // <--- maxLines
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Enter...',
            ),
          ),
        ),
      ),
    );
  }
}
