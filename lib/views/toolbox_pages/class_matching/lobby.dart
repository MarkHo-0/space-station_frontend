import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:space_station/api/interfaces/toolbox_api.dart';
import 'package:space_station/models/course.dart';

class CMlobbyPage extends StatefulWidget {
  const CMlobbyPage({super.key});

  @override
  State<CMlobbyPage> createState() => CMlobbyPageState();
}

class CMlobbyPageState extends State<CMlobbyPage> {
  CourseInfo? selectedCourse;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
              onPressed: () {},
              child: Text(
                context.getString("my_request"),
                style: const TextStyle(fontSize: 20),
              )),
        )
      ]),
      body: lobbybody(context),
    );
  }

  Widget lobbybody(BuildContext context) {
    String displayStringForOption(CourseInfo option) => option.courseCode;
    return Column(
      children: [
        Text(context.getString("request_swap_message")),
        RawAutocomplete<CourseInfo>(
          displayStringForOption: displayStringForOption,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (_) {
                  setState(() => selectedCourse = null);
                });
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Material(
              elevation: 4.0,
              child: ListView(
                  children: options
                      .map((option) => GestureDetector(
                            onTap: () {
                              onSelected(option);
                              setState(() => selectedCourse = option);
                            },
                            child: ListTile(
                              title: Text(option.courseCode),
                            ),
                          ))
                      .toList()),
            );
          },
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              selectedCourse = null;
              return [];
            }
            return getCourseInfo(textEditingValue.text)
                .then((value) => value.coursesArray)
                .onError((_, __) => []);
          },
        ),
        if (selectedCourse != null) showCourseName(context)
      ],
    );
  }

  Widget showCourseName(BuildContext context) {
    return Text(
      selectedCourse!.coureseName,
      style: TextStyle(color: Theme.of(context).hintColor),
    );
  }
}
