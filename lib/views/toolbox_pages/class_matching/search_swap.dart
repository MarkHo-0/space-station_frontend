import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/course.dart';

import '../../../models/courseswap.dart';

class SearchSwapPage extends StatefulWidget {
  final int selectedclass;
  final CourseInfo selectedcourse;
  const SearchSwapPage(this.selectedclass, this.selectedcourse, {super.key});

  @override
  State<SearchSwapPage> createState() => SearchSwapPageState();
}

class SearchSwapPageState extends State<SearchSwapPage> {
  final _scrollController = ScrollController();
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.selectedcourse.coureseName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          listbody(context)
        ],
      ),
    );
  }

  Widget listbody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(requests.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).shadowColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.getString("given_out")),
                      Text(
                        "CL${requests[index].classNum}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(left: 35, right: 35)),
                      child: Text(
                        context.getString("swap"),
                        style: const TextStyle(fontSize: 18),
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
}
