import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/forum_api.dart';
import 'package:space_station/models/comment.dart';
import 'package:space_station/views/_share/succuess_backlastpage.dart';
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
          title: Text(context.getString("report")),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SizedBox(
              height: 45,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    border: kRoundedBorder,
                    filled: true,
                    isDense: true,
                    fillColor: Theme.of(context).splashColor,
                    hintText:
                        "#${widget.comment.cid} ${widget.comment.sender.nickname}"),
                maxLines: 1,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: 45,
            child: ElevatedButton(
              onPressed: () => onPress(context, widget.comment.cid),
              child: Row(
                children: [
                  Text(context.getString("report")),
                  const Icon(
                    Icons.report,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPress(BuildContext context, int cid) {
    if (_selected != null) {
      reportComment(widget.comment.cid, _selected!)
          .then((value) => exit(context, value))
          .catchError((_) => repeatActionErrorDialog(context),
              test: (e) => e is FrquentError)
          .onError((_, __) => showUnkownErrorDialog(context));
    }
  }

  void exit(BuildContext context, bool value) {
    succussandbacklastpageDialog(context);
  }

  Widget commentInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
          height: 150,
          color: Theme.of(context).splashColor,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                context.getString("report_content"),
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              DynamicTextBox(widget.comment.content),
            ],
          ))),
    );
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
