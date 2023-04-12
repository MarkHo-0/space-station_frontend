import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/forum_api.dart';
import 'package:space_station/models/comment.dart';
import 'package:space_station/views/_share/general_error_dialog.dart';
import 'widgets/dynamic_textbox/dynamic_textbox.dart';

import '../../api/error.dart';
import '../_share/unknown_error_popup.dart';

// ignore: must_be_immutable
class ReportPage extends StatelessWidget {
  final Comment comment;
  final int floorIndex;
  final VoidCallback onReportSuccessed;
  ReportPage({
    required this.comment,
    required this.floorIndex,
    required this.onReportSuccessed,
    super.key,
  });

  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.getString("report"))),
      body: Column(
        children: [
          header(context),
          buildCommentPreview(context),
          const SizedBox(height: 30),
          buildReasonButtons(context),
        ],
      ),
    );
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
                    "Re: #${floorIndex + 1} ${comment.sender.nickname}",
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
                onPressed: () => performReport(context),
                label: Text(context.getString("report")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommentPreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        color: Theme.of(context).hoverColor,
        child: SingleChildScrollView(child: DynamicTextBox(comment.content)),
      ),
    );
  }

  Widget buildReasonButtons(BuildContext context) {
    final pColor = Theme.of(context).primaryColor;
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Column(
          children: List.generate(7, (index) {
            final reasonID = 6 - index + 1;
            return RadioListTile(
              value: reasonID,
              activeColor: pColor,
              title: Text(context.getString("report_reason_$reasonID")),
              onChanged: (_) => setState(() => _selected = reasonID),
              groupValue: _selected,
            );
          }),
        );
      },
    );
  }

  void performReport(BuildContext context) {
    if (_selected == null) return;
    reportComment(comment.cid, _selected!)
        .then((value) => onSuccessed(context))
        .catchError((_) => onRepeated(context), test: (e) => e is FrquentError)
        .onError((_, __) => showUnkownErrorDialog(context));
  }

  void onRepeated(BuildContext context) {
    showGeneralErrorDialog(context, "repeat_err_body");
  }

  void onSuccessed(BuildContext context) {
    onReportSuccessed();
    Navigator.pop(context);
  }
}
