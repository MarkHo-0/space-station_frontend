import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReplyPage extends StatefulWidget {
  final int cid;
  final int tid;
  const ReplyPage(this.cid, this.tid, {super.key});

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.getString("reply_title")),
        ),
        body: const Text(""));
  }
}
