import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/grade.dart';

class GradeSelector extends StatelessWidget {
  final GradeSelectorController controller;
  const GradeSelector(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: controller.value?.gradeIndex,
      items: buildItems(context),
      onChanged: (newGrade) => controller.value = Grade(newGrade!),
      menuMaxHeight: 300,
      decoration: InputDecoration(
        hintText: context.getString('aim_grade_hint'),
      ),
      validator: (value) {
        if (value == null) {
          return context.getString('field_is_required');
        }
        return null;
      },
    );
  }

  List<DropdownMenuItem<int>> buildItems(BuildContext context) {
    return List.generate(gradeNames.length, (index) {
      return DropdownMenuItem(
        value: index,
        child: Text(gradeNames[index]),
      );
    });
  }
}

class GradeSelectorController extends ValueNotifier<Grade?> {
  GradeSelectorController(super.value);
}
