import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/comment.dart';

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
    children.add(buttonGroup(context));
    children.add(_textfield(context));
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
            onPressed: () {},
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
                    FocusScope.of(context).unfocus();
                    _selected == index ? _selected = null : _selected = index;
                  })),
          Text(text)
        ],
      ),
    );
  }

  Widget _textfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onTap: () => setState(() {
          _selected = 0;
        }),
        decoration:
            InputDecoration(hintText: context.getString("report_message_hint")),
        style: TextStyle(
            color: _selected != 0 ? Theme.of(context).hintColor : null),
        maxLines: 5,
      ),
    );
  }
}
