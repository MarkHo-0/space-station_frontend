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
          child: DropdownButton<int>(
            elevation: 2,
            borderRadius: BorderRadius.circular(3),
            value: widget.controller.value,
            items: buildSelectorItems(context),
            selectedItemBuilder: (ctx) => buildSelectedItems(ctx),
            hint: buildItem(context.getString("page_dropdown_hint")),
            isDense: true,
            isExpanded: true,
            onChanged: (selected) => widget.controller.update(selected!),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> buildSelectorItems(BuildContext context) {
    List<DropdownMenuItem<int>> items = [];
    for (var i = 0; i < kForumTabs.length; i++) {
      var tab = kForumTabs[i];
      var hasChildren = tab.hasCategorySelector;
      items.add(DropdownMenuItem(
        enabled: !hasChildren,
        value: (i + 1) * 10,
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
        for (var j = 1; j <= tab.categoriesQuantity!; j++) {
          items.add(DropdownMenuItem(
            value: (i + 1) * 10 + j,
            child: Padding(
              padding: kLeftPadding,
              child: Text(context.getString("${tab.categoryKey}_$j")),
            ),
          ));
        }
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

class PageDropdownController extends ValueNotifier<int?> {
  int pageID = 0;
  int categoryID = 0;

  PageDropdownController() : super(null);

  void update(int newValue) {
    pageID = newValue ~/ 10;
    categoryID = newValue % 10;
    value = newValue;
  }
  
  bool get isEmpty => value == null;
  
  void clear() {
    pageID = 0;
    categoryID = 0;
    value = null;
  }
}
