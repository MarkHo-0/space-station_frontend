import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import '../../../models/study_partner_post.dart';
import '../../_share/contact_input/contact_field.dart';
import '../../_share/course_input.dart';
import '../../_share/titled_container.dart';
import '../../_share/unknown_error_popup.dart';
import 'widgets/aim_grade_selector.dart';

class StudyPartnerCreator extends StatefulWidget {
  final void Function(StudyPartnerPost) onCreated;
  final StudyPartnerPost? oldData;
  const StudyPartnerCreator({this.oldData, required this.onCreated, super.key});

  @override
  State<StudyPartnerCreator> createState() => _StudyPartnerCreatorState();
}

class _StudyPartnerCreatorState extends State<StudyPartnerCreator> {
  final formKey = GlobalKey<FormState>();
  final firstFocus = FocusNode();
  late CourseInputController courseCtl;
  late GradeSelectorController aimedGradeCtl;
  late TextEditingController descriptionCtl;
  late ContactInputController contactCtl;

  @override
  void initState() {
    super.initState();
    courseCtl = CourseInputController(widget.oldData?.course);
    aimedGradeCtl = GradeSelectorController(widget.oldData?.aimedGrade);
    descriptionCtl = TextEditingController(text: widget.oldData?.description);
    contactCtl = ContactInputController(widget.oldData?.contact);
    if (widget.oldData == null) firstFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildPostButtom(context)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: formKey,
            child: buildForumBody(context),
          ),
        ),
      ),
    );
  }

  Widget buildForumBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TitledField(
          title: context.getString('course'),
          body: CourseInput(courseCtl, focusNode: firstFocus),
        ),
        TitledField(
          title: context.getString('aim_grade'),
          body: GradeSelector(aimedGradeCtl),
        ),
        TitledField(
          title: context.getString('description'),
          body: buildDescriptionInput(context),
        ),
        TitledField(
          title: context.getString('contact'),
          body: ContactField(contactCtl),
        ),
        const SizedBox(height: 100),
      ],
    );
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

  Widget buildDescriptionInput(BuildContext context) {
    return TextFormField(
      controller: descriptionCtl,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: context.getString('description_hint'),
      ),
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.getString('field_is_required');
        }
        return null;
      },
    );
  }

  void onButtonPressed(BuildContext context) {
    if (!formKey.currentState!.validate()) return;
    final post = StudyPartnerPost(
      widget.oldData?.id ?? 0,
      widget.oldData?.publisherUserID ?? 0,
      aimedGradeCtl.value!,
      descriptionCtl.text,
      courseCtl.value!,
      contactCtl.value!,
    );
    (widget.oldData == null ? createPost(post) : editPost(post))
        .then((_) => onSuccess(context, post))
        .catchError((_) => showUnkownErrorDialog(context));
  }

  void onSuccess(BuildContext context, StudyPartnerPost post) {
    contactCtl.trySaveToLocal();
    widget.onCreated(post);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    courseCtl.dispose();
    aimedGradeCtl.dispose();
    descriptionCtl.dispose();
    contactCtl.dispose();
    super.dispose();
  }
}
