import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:space_station/models/courseswap.dart';

class ContactPage extends StatefulWidget {
  final SwapRequestRecord request;
  const ContactPage(this.request, {super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: infobody(context));
  }

  Widget infobody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(context.getString("swaped_action_msg")),
        Text(widget.request.course.courseCode),
        Row(
          children: [
            Text(
              "CL${widget.request.currentClassNum.toString().padLeft(2, '0')}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Icon(Icons.arrow_forward),
            Text(
              "CL${widget.request.expectedClassNum.toString().padLeft(2, '0')}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            )
          ],
        ),
        Column(
          children: [
            Text(widget.request.contactInfo.method.toString()),
            Text(widget.request.contactInfo.detail)
          ],
        )
      ],
    );
  }
}
