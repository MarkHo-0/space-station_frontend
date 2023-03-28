import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/course.dart';

class ClassSelector extends StatelessWidget {
  final ClassSelectorController controller;
  final CourseInfo? course;
  final int? excludedClass;
  final String? hintText;

  const ClassSelector({
    super.key,
    required this.controller,
    this.course,
    this.excludedClass,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      items: buildItems(context),
      onChanged: (classNumber) => controller.value = classNumber,
      menuMaxHeight: 300,
      decoration: InputDecoration(
        hintText: hintText,
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
    if (course == null) return [];
    final classCount = course!.maxClassNum - course!.minClassNum + 1;
    return List.generate(classCount, (index) {
      final currentClass = index + course!.minClassNum;
      return DropdownMenuItem(
        value: currentClass,
        enabled: currentClass != excludedClass,
        child: Text("CL${currentClass.toString().padLeft(2, '0')}"),
      );
    });
  }
}

class ClassSelectorController extends ValueNotifier<int?> {
  ClassSelectorController(super.value);

  bool get isEmpty => value == null;
}
