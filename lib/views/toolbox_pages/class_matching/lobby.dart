import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/other_api.dart';
import 'package:space_station/models/course.dart';
import 'package:space_station/views/toolbox_pages/class_matching/search_swap.dart';
import 'package:space_station/views/toolbox_pages/class_matching/widget/class_selector.dart';

import '../../_share/course_input.dart';
import '../../_share/titled_container.dart';

class CMlobbyPage extends StatefulWidget {
  const CMlobbyPage({super.key});

  @override
  State<CMlobbyPage> createState() => CMlobbyPageState();
}

class CMlobbyPageState extends State<CMlobbyPage> {
  final FocusNode _focusNode = FocusNode();
  final CourseInputController courseController = CourseInputController(null);
  final ClassSelectorController classController = ClassSelectorController(null);
  @override
  void initState() {
    super.initState();
    courseController.addListener(() => setState(() {}));
    classController.addListener(() => gotoSearchSwapPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
              onPressed: () {},
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
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        TitledField(
            title: context.getString("request_swap_message"),
            body: CourseInput(courseController, focusNode: _focusNode)),
        if (courseController.value != null)
          TitledField(
              title: context.getString("current_class"),
              body: classbody(context))
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
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return SearchSwapPage(classController.value!, courseController.value!);
    }));
  }
}
