import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/study_partner_post.dart';
import 'package:space_station/views/_share/contact_input/contact_field.dart';
import 'package:space_station/views/_share/titled_container.dart';
import 'package:space_station/views/_styles/textfield.dart';

class StudyPartnerPreviewer extends StatelessWidget {
  final StudyPartnerPost data;
  const StudyPartnerPreviewer(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildAimedGradeInfo(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCourseNameTitle(context),
            buildFullDescription(context),
            buildContactInfo(context),
          ],
        ),
      ),
    );
  }

  Widget buildCourseNameTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        data.course.coureseName,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget buildAimedGradeInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: context.getString('aim_grade')),
            const TextSpan(text: ' '),
            TextSpan(
              text: data.aimedGrade.toString(),
              style: const TextStyle(fontSize: 24),
            )
          ],
        ),
        style: TextStyle(color: Theme.of(context).dividerColor),
      ),
    );
  }

  Widget buildFullDescription(BuildContext context) {
    return TitledField(
      title: context.getString('description'),
      body: Container(
        height: 150,
        width: double.infinity,
        padding: kContentPadding,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).disabledColor),
        ),
        child: SingleChildScrollView(
          child: Text(data.description),
        ),
      ),
    );
  }

  Widget buildContactInfo(BuildContext context) {
    return TitledField(
      title: context.getString('contact'),
      body: ContactField(
        ContactInputController(data.contact),
        editable: false,
      ),
    );
  }
}
