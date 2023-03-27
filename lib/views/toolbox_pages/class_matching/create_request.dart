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

class SwapCreatePage extends StatefulWidget {
  final int currentClass;
  final CourseInfo targetCourse;
  const SwapCreatePage(this.currentClass, this.targetCourse, {super.key});

  @override
  State<SwapCreatePage> createState() => _SwapCreatePageState();
}

class _SwapCreatePageState extends State<SwapCreatePage> {
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
                body: Text(widget.targetCourse.coureseName),
              ),
              TitledField(
                title: context.getString("current_class"),
                body:
                    Text("CL${widget.currentClass.toString().padLeft(2, '0')}"),
              ),
              TitledField(
                title: context.getString("want_class"),
                body: SizedBox(
                  width: 300,
                  child: ClassSelector(
                    course: widget.targetCourse,
                    controller: expClassController,
                    excludedClass: widget.currentClass,
                  ),
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
      widget.currentClass,
      expClassController.value!,
      contactCtl.value!,
      widget.targetCourse.courseCode,
    );

    showConfirmationDialog(context, "send_request", () {
      createSwapRequest(request)
          .then((_) => onCreateSuccessed(context))
          .onError((_, __) => showUnkownErrorDialog(context));
    });
  }

  void onCreateSuccessed(BuildContext context) {
    contactCtl.trySaveToLocal();
    Navigator.pop(context);
  }
}
