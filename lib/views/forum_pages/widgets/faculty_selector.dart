import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

//真實是有6個，多出的那個代表全部學系
const facultiesCount = 7;

class FacultySelector extends StatefulWidget {
  final void Function(int fid) onFacultyChanged;

  const FacultySelector({super.key, required this.onFacultyChanged});

  @override
  State<FacultySelector> createState() => _FacultySelectorState();
}

class _FacultySelectorState extends State<FacultySelector> {
  int selectedFaculty = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton<int>(
          value: selectedFaculty,
          items: getItems(context),
          onChanged: (newFaculty) {
            selectedFaculty = newFaculty!;
            setState(() {});
            widget.onFacultyChanged(selectedFaculty);
          },
          isDense: true,
          alignment: Alignment.center,
          underline: const SizedBox(),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> getItems(BuildContext context) {
    return List.generate(
      facultiesCount,
      (facultyID) => DropdownMenuItem<int>(
        value: facultyID,
        child: Text(
          "faculty_$facultyID".i18n(),
          style: facultyID == 0
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
        ),
      ),
      growable: false,
    );
  }
}
