import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/course.dart';
import 'package:space_station/views/toolbox_pages/class_matching/create_request.dart';

import '../../../models/courseswap.dart';

class SearchSwapPage extends StatefulWidget {
  final int selectedclass;
  final CourseInfo selectedcourse;
  const SearchSwapPage(this.selectedclass, this.selectedcourse, {super.key});

  @override
  State<SearchSwapPage> createState() => SearchSwapPageState();
}

class SearchSwapPageState extends State<SearchSwapPage> {
  List<SearchRequest> requests = [];
  @override
  void initState() {
    super.initState();
    getrequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.getString("found_time_slots"))),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.selectedcourse.coureseName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            listbody(context),
            createHintBody(context)
          ],
        ),
      ),
    );
  }

  Widget listbody(BuildContext context) {
    if (requests.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(context.getString("no_time_slots"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: List.generate(requests.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).dividerColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.getString("given_out")),
                      Text(
                        "CL${requests[index].classNum.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(35, 10, 35, 10)),
                      child: Text(
                        context.getString("swap"),
                        style: const TextStyle(fontSize: 20),
                      ))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void getrequests() {
    searchRequest(widget.selectedcourse.courseCode, widget.selectedclass)
        .then((value) => setValue(value))
        .onError((e, _) {});
  }

  void setValue(SearchRequests value) {
    setState(() {
      requests = value.requestArray;
    });
  }

  Widget createHintBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            context.getString("create_swap_hint"),
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: ((_) {
                  return SwapCreatePage(
                      widget.selectedclass, widget.selectedcourse);
                }),
              ));
            },
            child: Text(context.getString("create_swap")),
          ),
        ],
      ),
    );
  }
}
