import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  final int cid;
  const ReportPage(this.cid, {super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.getString("report_title")),
        ),
        body: const Text(""));
  }
}
