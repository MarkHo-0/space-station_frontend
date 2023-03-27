import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/courseswap.dart';
import 'package:space_station/views/_share/contact_input/contact_field.dart';
import 'widget/class_exchange_view.dart';

class ContactPage extends StatelessWidget {
  final SwapRequestRecord request;
  const ContactPage(this.request, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            request.course.courseCode,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ClassExchangeView(
              left: request.expectedClassNum,
              right: request.currentClassNum,
            ),
          ),
          const SizedBox(height: 20),
          Text(context.getString("swaped_action_msg")),
          ContactField(
            ContactInputController(request.contactInfo),
            editable: false,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.getString('finish')),
          )
        ],
      ),
    );
  }
}
