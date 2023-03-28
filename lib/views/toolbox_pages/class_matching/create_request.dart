import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/courseswap.dart';

import '../../_share/titled_container.dart';
import 'widget/class_selector.dart';
import '../../../models/course.dart';
import '../../_share/before_repost_popup.dart';
import '../../_share/contact_input/contact_field.dart';
import '../../_share/unknown_error_popup.dart';

class SwapCreatePage extends StatelessWidget {
  final int currentClass;
  final CourseInfo targetCourse;
  SwapCreatePage({
    required this.currentClass,
    required this.targetCourse,
    super.key,
  });

  final contactCtl = ContactInputController(null);
  final expClassController = ClassSelectorController(null);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [buildPostButtom(context)]),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitledField(
                title: context.getString("course"),
                body: Text(targetCourse.coureseName),
              ),
              TitledField(
                title: context.getString("current_class"),
                body: Text("CL${currentClass.toString().padLeft(2, '0')}"),
              ),
              TitledField(
                title: context.getString("want_class"),
                body: ClassSelector(
                  course: targetCourse,
                  controller: expClassController,
                  excludedClass: currentClass,
                  hintText: context.getString("want_class_hint"),
                ),
              ),
              TitledField(
                title: context.getString('contact'),
                body: ContactField(contactCtl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPostButtom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: ElevatedButton(
        onPressed: () => performPost(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(context.getString('submit')),
        ),
      ),
    );
  }

  void performPost(BuildContext context) {
    if (formKey.currentState!.validate() == false) return;

    final request = SwapRequest(
      currentClass,
      expClassController.value!,
      contactCtl.value!,
      targetCourse.courseCode,
    );

    showConfirmationDialog(context, "send_request", () {
      createSwapRequest(request)
          .then((_) => onCreateSuccessed(context))
          .catchError((_) => showUnkownErrorDialog(context));
    });
  }

  void onCreateSuccessed(BuildContext context) {
    contactCtl.trySaveToLocal();
    contactCtl.dispose();
    expClassController.dispose();
    Navigator.pop(context);
  }
}
