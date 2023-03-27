import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/courseswap.dart';
import 'widget/class_exchange_view.dart';
import '../../_share/before_remove_popup.dart';
import '../../_share/contact_input/contact_field.dart';
import '../../../providers/auth_provider.dart';
import '../../_share/before_repost_popup.dart';
import '../../_share/unknown_error_popup.dart';

class SwapRecordPage extends StatefulWidget {
  const SwapRecordPage({super.key});

  @override
  State<SwapRecordPage> createState() => _SwapRecordPageState();
}

class _SwapRecordPageState extends State<SwapRecordPage> {
  List<SwapRequestRecord> record = [];
  int? myUserID;

  @override
  void initState() {
    super.initState();
    fetchRecords();
    myUserID = getLoginedUser(context)?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.getString("my_request"))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: buildRecords(context),
      ),
    );
  }

  Widget buildRecords(BuildContext context) {
    if (record.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          context.getString("no_swap_request"),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        record.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: buildRecordItem(context, index),
          );
        },
      ),
    );
  }

  Widget buildRecordItem(BuildContext context, int index) {
    final request = record[index];
    final isMine = isMyRequest(index);
    final lClass = isMine ? request.currentClassNum : request.expectedClassNum;
    final rClass = isMine ? request.expectedClassNum : request.currentClassNum;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.course.coureseName,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          ClassExchangeView(left: lClass, right: rClass),
          buildRecordItemFooter(context, index)
        ],
      ),
    );
  }

  Widget buildRecordItemFooter(BuildContext context, int index) {
    if (record[index].responserUid == null) {
      return buildStatusByMeNoResponse(context, index);
    }

    if (isMyRequest(index)) {
      return buildStatusByMeHasResponse(context, index);
    }

    return buildStatusByOther(context, index);
  }

  Widget buildStatusByMeNoResponse(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.getString("waiting_msg")),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ElevatedButton(
            onPressed: () => onRemoveRequest(context, index),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Container(
              alignment: Alignment.center,
              width: 110,
              child: Text(
                context.getString("remove"),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildStatusByMeHasResponse(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.getString("accepted_request_msg1")),
            Text(context.getString("accepted_request_msg2"))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ElevatedButton(
            onPressed: () => onRepostRequest(context, index),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10)),
            child: Container(
              alignment: Alignment.center,
              width: 110,
              child: Text(
                context.getString("repost"),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildStatusByOther(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.getString("accpeted_request")),
        ContactField(
          ContactInputController(record[index].contactInfo),
          editable: false,
        ),
      ],
    );
  }

  void fetchRecords() {
    getSwapRecord().then((reuslt) {
      record = reuslt.swaprequestArray;
      setState(() {});
    }).onError((_, __) => null);
  }

  void onRemoveRequest(BuildContext context, int index) {
    if (isMyRequest(index) == false) return;
    showRemoveConfirmation(context, () {
      removeRequest(record[index].id).then((_) {
        record.removeAt(index);
        setState(() {});
        if (record.isEmpty) Navigator.pop(context);
      }).onError((_, __) {
        showUnkownErrorDialog(context);
      });
    });
  }

  void onRepostRequest(BuildContext context, int index) {
    if (isMyRequest(index) == false) return;
    showConfirmationDialog(context, "repost_msg", () {
      repostRequest(record[index].id).then((value) {
        record[index].responserUid = null;
        setState(() {});
      }).onError((_, __) {
        showUnkownErrorDialog(context);
      });
    });
  }

  bool isMyRequest(int index) => record[index].requesterUid == myUserID;
}
