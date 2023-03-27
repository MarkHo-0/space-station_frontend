import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import '../../api/interfaces/other_api.dart';
import '../../models/course.dart';

class CourseInput extends StatefulWidget {
  final FocusNode focusNode;
  final CourseInputController controller;
  const CourseInput(this.controller, {required this.focusNode, super.key});

  @override
  State<CourseInput> createState() => _CourseInputState();
}

class _CourseInputState extends State<CourseInput> {
  late TextEditingController myTextEditCtl;

  @override
  void initState() {
    super.initState();
    myTextEditCtl = TextEditingController(text: widget.controller.name);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<CourseInfo>(
        focusNode: widget.focusNode,
        textEditingController: myTextEditCtl,
        fieldViewBuilder: (ctx, textCtl, fNode, onFiredSubmit) {
          return TextFormField(
            controller: textCtl,
            focusNode: fNode,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            textInputAction: TextInputAction.next,
            onTap: () => textCtl.clear(),
            decoration: InputDecoration(
              hintText: 'Search by Course Code/Course English Name',
            ),
            onTapOutside: (event) {
              if (widget.controller.value == null) {
                textCtl.clear();
              } else {
                textCtl.text = widget.controller.name;
              }
              fNode.unfocus();
            },
            onFieldSubmitted: (_) => onFiredSubmit(),
            validator: (_) {
              if (widget.controller.value == null) {
                textCtl.clear();
                return context.getString('field_is_required');
              } else {
                textCtl.text = widget.controller.name;
              }
              return null;
            },
          );
        },
        displayStringForOption: (option) => option.coureseName,
        optionsViewBuilder: (ctx, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: constraints.biggest.width,
                color: Theme.of(ctx).hoverColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options.map((option) {
                    return ListTile(
                      title: Text(
                        option.coureseName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(option.courseCode),
                      onTap: () {
                        widget.controller.value = option;
                        onSelected(option);
                        widget.focusNode.unfocus();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) return [];
          return getCourseInfo(textEditingValue.text)
              .then((value) => value.coursesArray)
              .onError((_, __) => []);
        },
        onSelected: (option) {},
      ),
    );
  }

  @override
  void dispose() {
    myTextEditCtl.dispose();
    super.dispose();
  }
}

class CourseInputController extends ValueNotifier<CourseInfo?> {
  CourseInputController(super.value);
  String get name => isEmpty ? '' : value!.coureseName;
  String get code => isEmpty ? '' : value!.courseCode;

  bool get isEmpty => value == null;

  bool get swappable => !isEmpty && value!.maxClassNum > value!.minClassNum;
}
