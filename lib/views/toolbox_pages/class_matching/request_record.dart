import 'dart:math';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/api/interfaces/user_api.dart';
import 'package:space_station/models/courseswap.dart';
import 'package:space_station/views/_share/before_remove_popup.dart';
import 'package:space_station/views/_share/contact_input/contact_field.dart';

import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';
import '../../_share/before_repost_popup.dart';

class RequestRecordPage extends StatefulWidget {
  const RequestRecordPage({super.key});

  @override
  State<RequestRecordPage> createState() => _RequestRecordPageState();
}

class _RequestRecordPageState extends State<RequestRecordPage> {
  List<SwapRequestRecord> swaprequestlist = [];
  @override
  Widget build(BuildContext context) {
    getrequest();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.getString("my_request"),
        ),
      ),
      body: listitem(context),
    );
  }

  Widget listitem(BuildContext context) {
    if (swaprequestlist.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Text(context.getString("no_swap_request"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          swaprequestlist.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).dividerColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      swaprequestlist[index].course.coureseName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Row(
                      children: [
                        Text(
                          "CL${swaprequestlist[index].currentClassNum.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const Icon(Icons.arrow_forward),
                        Text(
                          "CL${swaprequestlist[index].expectedClassNum.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        )
                      ],
                    ),
                    requestStat(context, index)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void getrequest() {
    getSwapRecord().then((value) => setValue(value)).onError((_, __) => null);
  }

  void setValue(SwapRequestRecords value) {
    setState(() {
      swaprequestlist = value.swaprequestArray;
    });
  }

  Widget requestStat(BuildContext context, int index) {
    if (swaprequestlist[index].requesterUid == getuserUid(context)) {
      if (swaprequestlist[index].reponserUid == null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.getString("waiting_msg")),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                  onPressed: () => setState(() {
                        onRemoveRequest(context, swaprequestlist[index].id);
                      }),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10)),
                  child: Text(
                    context.getString("remove"),
                    style: const TextStyle(fontSize: 18),
                  )),
            )
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(context.getString("accepted_request_msg1")),
              Text(context.getString("accepted_request_msg2"))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
                onPressed: () => setState(() {
                      onRepostRequest(context, swaprequestlist[index].id);
                    }),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10)),
                child: Text(
                  context.getString("repost"),
                  style: const TextStyle(fontSize: 18),
                )),
          )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.getString("accpeted_request")),
        ContactField(ContactInputController(swaprequestlist[index].contactInfo),
            editable: false),
      ],
    );
  }

  void onRemoveRequest(BuildContext context, int id) {
    showRemoveConfirmation(context, () {
      removeRequest(id).then((value) => (null)).onError((_, __) => null);
    });
  }

  void onRepostRequest(BuildContext context, int id) {
    showConfirmationDialog(context, "repost_msg", () {
      repostRequest(id).then((value) => null).onError((_, __) => null);
    });
  }

  int getuserUid(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.isLogined) return auth.user!.uid;
    return 0;
  }
}
