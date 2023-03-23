import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/grade.dart';

class ClassSelector extends StatelessWidget {
  final ClassSelectorController controller;
  final List<int> classArray;

  const ClassSelector(this.controller, {super.key, required this.classArray});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      items: buildItems(context),
      onChanged: (index) => controller.value = classArray[index!],
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
    return List.generate(classArray.length, (index) {
      return DropdownMenuItem(
        value: index,
        child: Text("CL${classArray[index]}"),
      );
    });
  }
}

class ClassSelectorController extends ValueNotifier<int?> {
  ClassSelectorController(super.value);
}
