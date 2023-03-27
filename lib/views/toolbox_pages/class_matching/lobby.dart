import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/error.dart';
import 'package:space_station/views/toolbox_pages/class_matching/request_record.dart';
import 'package:space_station/views/toolbox_pages/class_matching/search_swap.dart';
import 'package:space_station/views/toolbox_pages/class_matching/widget/class_selector.dart';

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
  final courseController = CourseInputController(null);
  final classController = ClassSelectorController(null);
  @override
  void initState() {
    super.initState();
    courseController.addListener(onCourseSelected);
    classController.addListener(onClassSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [buildRecordButton(context)]),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitledField(
              title: context.getString("request_swap_message"),
              body: CourseInput(
                courseController,
                focusNode: FocusNode(),
              ),
            ),
            Visibility(
              visible: courseController.value != null,
              child: TitledField(
                title: context.getString("current_class"),
                body: ClassSelector(
                  controller: classController,
                  course: courseController.value,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
            return const SwapRecordPage();
          }));
        },
        child: Text(context.getString("my_request")),
      ),
    );
  }

  void onCourseSelected() {
    if (courseController.swappable == false) {
      clearInput();
      return repeatActionErrorDialog(context);
    }
    classController.value = null;
    setState(() {});
  }

  void onClassSelected() {
    if (classController.value == null) return;
    searchRequest(courseController.value!.courseCode, classController.value!)
        .then((value) => onSearchSuccessed(value))
        .catchError(
          (_, __) => showCourseRepeatedError(context),
          test: (e) => e is FrquentError,
        )
        .onError((e, _) {});
  }

  void onSearchSuccessed(SearchRequests result) {
    final course = courseController.value!;
    final classNumber = classController.value!;
    clearInput();
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return SearchSwapPage(
        searchCourse: course,
        searchClass: classNumber,
        result: result.requestArray,
      );
    }));
  }

  void showCourseRepeatedError(BuildContext context) {}

  void clearInput() {
    courseController.value = null;
    classController.value = null;
    setState(() {});
  }

  @override
  void dispose() {
    courseController.dispose();
    classController.dispose();
    super.dispose();
  }
}
