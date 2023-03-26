import 'dart:html';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/toolbox_pages/class_matching/request_record.dart';
import 'package:space_station/views/toolbox_pages/class_matching/search_swap.dart';
import 'package:space_station/views/toolbox_pages/class_matching/widget/class_selector.dart';

import '../../../api/error.dart';
import '../../../api/interfaces/toolbox_api.dart';
import '../../../models/courseswap.dart';
import '../../_share/course_input.dart';
import '../../_share/repeat_action_error.dart';
import '../../_share/titled_container.dart';

class CMlobbyPage extends StatefulWidget {
  const CMlobbyPage({super.key});

  @override
  State<CMlobbyPage> createState() => CMlobbyPageState();
}

class CMlobbyPageState extends State<CMlobbyPage> {
  List<SearchRequest> requestlist = [];
  final FocusNode _focusNode = FocusNode();
  late CourseInputController courseController = CourseInputController(null);
  late ClassSelectorController classController = ClassSelectorController(null);

  @override
  void initState() {
    super.initState();
    courseController.addListener(() => setState(() {}));
    classController.addListener(() => setState(() => gotoSearchSwapPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
                  return const RequestRecordPage();
                }));
              },
              child: Text(
                context.getString("my_request"),
                style: const TextStyle(fontSize: 20),
              )),
        )
      ]),
      body: lobbybody(context),
    );
  }

  Widget lobbybody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitledField(
            title: context.getString("request_swap_message"),
            body: CourseInput(courseController, focusNode: _focusNode)),
        if (courseController.value != null)
          TitledField(
              title: context.getString("current_class"),
              body: classbody(context)),
      ]),
    );
  }

  Widget classbody(BuildContext context) {
    List<int> classArray = [];
    for (int i = courseController.value!.minClassNum;
        i < courseController.value!.maxClassNum + 1;
        i++) {
      classArray.add(i);
    }
    return ClassSelector(classController, classArray: classArray);
  }

  void gotoSearchSwapPage() {
    requestlist = [];
    searchRequest(courseController.value!.courseCode, classController.value!)
        .then((value) => setValue(value))
        .catchError((_) => repeat(context), test: (e) => e is FrquentError)
        .onError((e, _) {});
  }

  void repeat(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const CMlobbyPage(),
      ),
    );
    repeatActionErrorDialog(context);
  }

  void setValue(SearchRequests value) {
    setState(() {
      requestlist = value.requestArray;
    });

    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return SearchSwapPage(classController, courseController, requestlist);
    }));
  }
}
