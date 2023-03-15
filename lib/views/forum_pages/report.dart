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
  final int index;
  const ReportPage(this.comment, this.index, {super.key});

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
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Re: #${widget.index + 1} ${widget.comment.sender.nickname}",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.report),
                onPressed: () => onPress(context, widget.comment.cid),
                label: Text(context.getString("report")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPress(BuildContext context, int cid) {
    if (_selected != null) {
      reportComment(widget.comment.cid, _selected!)
          .then((value) => exit(context))
          .catchError((_) => repeatActionErrorDialog(context),
              test: (e) => e is FrquentError)
          .onError((_, __) => showUnkownErrorDialog(context));
    }
  }

  void exit(BuildContext context) {
    succussandbacklastpageDialog(context);
  }

  Widget commentInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        color: Theme.of(context).hoverColor,
        child: SingleChildScrollView(
            child: DynamicTextBox(widget.comment.content)),
      ),
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
