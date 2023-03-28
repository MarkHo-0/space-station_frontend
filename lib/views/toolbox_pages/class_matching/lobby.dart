import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/error.dart';
import 'package:space_station/views/_share/general_error_dialog.dart';
import 'package:space_station/views/toolbox_pages/class_matching/create_request.dart';

import '../../_share/unknown_error_popup.dart';
import 'request_record.dart';
import 'search_swap.dart';
import 'widget/class_selector.dart';
import '../../../api/interfaces/toolbox_api.dart';
import '../../../models/courseswap.dart';
import '../../_share/course_input.dart';
import '../../_share/titled_container.dart';

class CMlobbyPage extends StatefulWidget {
  const CMlobbyPage({super.key});

  @override
  State<CMlobbyPage> createState() => CMlobbyPageState();
}

class CMlobbyPageState extends State<CMlobbyPage> {
  final courseController = CourseInputController(null);
  final classController = ClassSelectorController(null);
  final firstFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    courseController.addListener(onCourseUpdated);
    classController.addListener(onClassUpdated);
    firstFocus.requestFocus();
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
                focusNode: firstFocus,
              ),
            ),
            Visibility(
              visible: courseController.value != null,
              child: TitledField(
                title: context.getString("current_class"),
                body: ClassSelector(
                  controller: classController,
                  course: courseController.value,
                  hintText: context.getString('current_class_hint'),
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
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
            return const SwapRecordPage();
          }));
        },
        child: Text(context.getString("swap_records")),
      ),
    );
  }

  void onCourseUpdated() {
    if (courseController.isEmpty) return;
    if (courseController.value!.isSingleClass) {
      return showSingleClassError(context);
    }
    classController.value = null;
    setState(() {});
  }

  void onClassUpdated() {
    if (classController.isEmpty) return;
    searchRequest(courseController.value!.courseCode, classController.value!)
        .then((result) => onSearchSuccessed(result))
        .onError(
          (_, __) => showCourseRepeatedError(context),
          test: (e) => e is FrquentError,
        )
        .catchError((_) => showUnkownErrorDialog(context));
  }

  void onSearchSuccessed(SearchRequests result) {
    final course = courseController.value!;
    final classNumber = classController.value!;
    clearScreen();
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      if (result.requestArray.isEmpty) {
        return SwapCreatePage(
          currentClass: classNumber,
          targetCourse: course,
        );
      }

      return SearchSwapPage(
        searchCourse: course,
        searchClass: classNumber,
        result: result.requestArray,
      );
    }));
  }

  void showCourseRepeatedError(BuildContext context) {
    showGeneralErrorDialog(context, 'course_repeated_error')
        .then((_) => clearScreen(focusAfterClear: true));
  }

  void showSingleClassError(BuildContext context) {
    showGeneralErrorDialog(context, 'single_class_error')
        .then((_) => clearScreen(focusAfterClear: true));
  }

  void clearScreen({bool focusAfterClear = false}) {
    courseController.value = null;
    classController.value = null;
    setState(() {});
    if (focusAfterClear) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        firstFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    courseController.dispose();
    classController.dispose();
    firstFocus.dispose();
    super.dispose();
  }
}
