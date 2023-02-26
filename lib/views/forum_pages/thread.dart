import 'package:flutter/material.dart';

class ThreadPage extends StatelessWidget {
  final int threadID;
  const ThreadPage(this.threadID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thread ID: $threadID"),
      ),
    );
  }
}
