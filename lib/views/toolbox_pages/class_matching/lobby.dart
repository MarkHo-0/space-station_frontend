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
    String displayStringForOption(CourseInfo option) => option.coureseName;

    return Column(
      children: [
        Text(context.getString("request_swap_message")),
        Autocomplete<CourseInfo>(
          displayStringForOption: displayStringForOption,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) return [];
            return getCourseInfo(textEditingValue.text)
                .then((value) => value.coursesArray)
                .onError((_, __) => []);
          },
          onSelected: (CourseInfo course) {},
        )
      ],
    );
  }
}
