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
import '../../_share/nooptiondialog.dart';
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
  CourseInputController courseController = CourseInputController(null);
  ClassSelectorController classController = ClassSelectorController(null);
  @override
  void initState() {
    super.initState();
    courseController.addListener(() => setState(() {}));
    classController.addListener(() => setState(() => gotoSearchSwapPage()));
    refresh();
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
      body: RefreshIndicator(
          onRefresh: () => refresh(), child: lobbybody(context)),
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
    if (courseController.value!.maxClassNum !=
        courseController.value!.minClassNum) {
      searchRequest(courseController.value!.courseCode, classController.value!)
          .then((value) => setValue(value))
          .catchError((_) => repeat(context), test: (e) => e is FrquentError)
          .onError((e, _) {});
    } else {
      refresh();
      noOptionDialog(context, "no_swap_msg");
    }
  }

  void repeat(BuildContext context) {
    refresh();
    repeatActionErrorDialog(context);
  }

  void setValue(SearchRequests value) {
    setState(() {
      requestlist = value.requestArray;
    });

    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return SearchSwapPage(
        classController,
        courseController,
        requestlist,
        onExited: (isExited) {
          if (isExited == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
          }
        },
      );
    }));
  }

  Future<void> refresh() {
    setState(() {
      courseController.value = null;
      classController.value = null;
    });
    return Future.value();
  }
}
