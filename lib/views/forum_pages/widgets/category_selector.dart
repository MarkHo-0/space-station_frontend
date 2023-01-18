// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class CategorySelector extends StatelessWidget {
  final String categoryKey;
  final int quantity;
  final int categoryID;
  final void Function(int categoryID) onChanged;

  const CategorySelector({
    super.key,
    required this.categoryKey,
    required this.quantity,
    required this.categoryID,
    required this.onChanged,
  });

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
          value: categoryID,
          items: getItems(context),
          onChanged: (newCategory) {
            onChanged(newCategory!);
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
      quantity + 1,
      (index) => DropdownMenuItem<int>(
        value: index,
        child: Text(
          "${categoryKey}_$index".i18n(),
          style:
              index == 0 ? TextStyle(color: Theme.of(context).hintColor) : null,
        ),
      ),
      growable: false,
    );
  }
}
