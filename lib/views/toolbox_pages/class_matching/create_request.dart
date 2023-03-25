import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/contact_info.dart';
import 'package:space_station/models/courseswap.dart';
import 'package:space_station/views/_share/titled_container.dart';
import 'package:space_station/views/toolbox_pages/class_matching/widget/class_selector.dart';

import '../../../api/error.dart';
import '../../../models/course.dart';
import '../../_share/contact_input/contact_field.dart';
import '../../_share/course_input.dart';
import '../../_share/repeat_action_error.dart';
import 'lobby.dart';

class SwapCreatePage extends StatefulWidget {
  final int selectedclass;
  final CourseInfo selectedcourse;
  const SwapCreatePage(this.selectedclass, this.selectedcourse, {super.key});

  @override
  State<SwapCreatePage> createState() => _SwapCreatePageState();
}

class _SwapCreatePageState extends State<SwapCreatePage> {
  ContactInputController contactCtl = ContactInputController(null);
  final ClassSelectorController wantclassController =
      ClassSelectorController(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: body(context));
  }

  Widget body(BuildContext context) {
    List<int> classArray = [];
    for (int i = widget.selectedcourse.minClassNum;
        i < widget.selectedcourse.maxClassNum + 1;
        i++) {
      if (i != widget.selectedclass) classArray.add(i);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitledField(
            title: context.getString("course"),
            body: selectedcoursebody(context)),
        TitledField(title: "current_class", body: selectedclassbody(context)),
        TitledField(
            title: context.getString("want_class"),
            body: ClassSelector(wantclassController, classArray: classArray)),
        TitledField(
            title: context.getString('contact'),
            body: ContactField(contactCtl)),
        buildPostButtom(context)
      ],
    );
  }

  Widget selectedcoursebody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.selectedcourse.coureseName),
        Text(widget.selectedcourse.courseCode)
      ],
    );
  }

  Widget selectedclassbody(BuildContext context) {
    return Text("CL${widget.selectedclass.toString().padLeft(2, '0')}");
  }

  Widget buildPostButtom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: ElevatedButton(
        onPressed: () => onButtonPressed(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(context.getString('submit')),
        ),
      ),
    );
  }

  void onButtonPressed(BuildContext context) {
    if (wantclassController.value != null && contactCtl.value != null) {
      final request = SwapRequest(
          widget.selectedclass,
          wantclassController.value!,
          contactCtl.value!,
          widget.selectedcourse.courseCode);
      createSwapRequest(request).then((_) => onSuccess(context)).catchError(
          (_) => repeatActionErrorDialog(context),
          test: (e) => e is FrquentError);
    }
  }

  void onSuccess(BuildContext context) {
    contactCtl.trySaveToLocal();
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 3;
    });
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (_) {
        return const CMlobbyPage();
      },
    ));
  }
}
