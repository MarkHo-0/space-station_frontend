import 'dart:math';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/constant.dart';
import '../../_styles/textfield.dart';

class PageDropdown extends StatefulWidget {
  final PageDropdownController controller;
  const PageDropdown({super.key, required this.controller});

  @override
  State<PageDropdown> createState() => _PageDropdownState();
}

class _PageDropdownState extends State<PageDropdown> {
  @override
  void initState() {
    widget.controller.addListener(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<double>(
            elevation: 2,
            borderRadius: BorderRadius.circular(3),
            value: widget.controller.value,
            items: buildSelectorItems(context),
            selectedItemBuilder: (ctx) => buildSelectedItems(ctx),
            hint: buildItem(context.getString("page_dropdown_hint")),
            isDense: true,
            isExpanded: true,
            onChanged: (value) => widget.controller.update(value!),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<double>> buildSelectorItems(BuildContext context) {
    List<DropdownMenuItem<double>> items = [];
    for (var i = 0; i < kForumTabs.length; i++) {
      var tab = kForumTabs[i];
      var hasChildren = tab.hasCategorySelector;
      items.add(DropdownMenuItem(
        enabled: !hasChildren,
        value: (i + 1).toDouble(),
        child: Text(
          context.getString("page_${tab.key}"),
          style: hasChildren
              ? TextStyle(
                  color: Theme.of(context).disabledColor,
                )
              : null,
        ),
      ));
      if (hasChildren) {
        items.addAll(List.generate(tab.categoriesQuantity!, (j) {
          j = j + 1;
          return DropdownMenuItem(
            value: (i + 1) + (j / pow(10, j.toString().length)),
            child: Padding(
              padding: kLeftPadding,
              child: Text(context.getString("${tab.categoryKey}_$j")),
            ),
          );
        }));
      }
    }
    return items;
  }

  List<Widget> buildSelectedItems(BuildContext context) {
    List<Widget> items = [];
    for (final tab in kForumTabs) {
      final pageName = context.getString("page_${tab.key}");
      items.add(buildItem(pageName));

      if (tab.hasCategorySelector) {
        items.addAll(
          List.generate(tab.categoriesQuantity!, (catIdx) {
            final cat = context.getString("${tab.categoryKey}_${catIdx + 1}");
            return buildItem("$pageName / $cat");
          }),
        );
      }
    }
    return items;
  }

  Widget buildItem(String text) {
    return Padding(
      padding: kLeftPadding,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }

  void update() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(update);
    super.dispose();
  }
}

class PageDropdownController extends ValueNotifier<double?> {
  int pageID = 0;
  int categoryID = 0;

  PageDropdownController() : super(null);

  void update(double newValue) {
    final temp = newValue.toString().split('.');
    pageID = int.parse(temp[0]);
    categoryID = int.parse(temp[1]);
    super.value = newValue;
  }

  bool get isEmpty => super.value == null;
  void clear() => super.value = null;
}
