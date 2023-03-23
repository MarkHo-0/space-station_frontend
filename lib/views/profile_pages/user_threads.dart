
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/user_api.dart';
import 'package:space_station/views/_share/thread_listview.dart';

class UserThreadsPage extends StatelessWidget {
  final int userID;
  const UserThreadsPage(this.userID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.getString('your_threads'))),
      body: ThreadListView(onRequest: (String cursor) {
        return getUserThreads(userID, cursor);
      }),
    );
  }
}
