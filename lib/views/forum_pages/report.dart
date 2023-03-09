import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/forum_api.dart';
import 'package:space_station/models/comment.dart';
import 'package:space_station/views/forum_pages/widgets/dynamic_textbox/dynamic_textbox.dart';

import '../../api/error.dart';
import '../_share/repeat_action_error.dart';
import '../_share/unknown_error_popup.dart';
import '../_styles/textfield.dart';

class ReportPage extends StatefulWidget {
  final Comment comment;
  const ReportPage(this.comment, {super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int? _selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.getString("report_title")),
        ),
        body: bodylayout(context));
  }

  Widget bodylayout(BuildContext context) {
    final children = <Widget>[];
    children.add(header(context));
    children.add(commentInfo(context));
    children.add(buttonGroup(context));
    return Column(children: children);
  }

  Widget header(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                  border: kRoundedBorder,
                  filled: true,
                  fillColor: Theme.of(context).splashColor,
                  hintText:
                      "${context.getString("report_action")}: #${widget.comment.cid} ${widget.comment.sender.nickname}"),
              maxLines: 1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: ElevatedButton(
            onPressed: () => onPress(context, widget.comment.cid),
            child: Row(
              children: [
                Text(context.getString("report_action")),
                const Icon(
                  Icons.report,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onPress(BuildContext context, int cid) {
    if (_selected != 0) {
      reportComment(widget.comment.cid, _selected!)
          .then((value) => exit(context, value))
          .catchError((_) => repeatActionErrorDialog(context),
              test: (e) => e is FrquentError)
          .onError((_, __) => showUnkownErrorDialog(context));
    }
  }

  void exit(BuildContext context, bool value) {
    ///////
    ///////
  }

  Widget commentInfo(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
            color: Theme.of(context).splashColor,
            child: DynamicTextBox(widget.comment.content)));
  }

  Widget buttonGroup(BuildContext context) {
    final children = <Widget>[];
    for (var i = 1; i <= 7; i++) {
      children.add(_button(i, context.getString("report_reason_$i")));
    }
    children.add(_button(0, context.getString("report_reason_0")));
    return Column(children: children);
  }

  Widget _button(int index, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Row(
        children: [
          InkResponse(
              child: Icon(
                _selected == index
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color:
                    _selected == index ? Theme.of(context).primaryColor : null,
                size: 30,
              ),
              onTap: () => setState(() {
                    _selected == index ? _selected = null : _selected = index;
                  })),
          Text(text)
        ],
      ),
    );
  }
}
