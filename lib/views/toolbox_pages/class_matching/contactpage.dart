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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              request.course.coureseName,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ClassExchangeView(
                left: request.expectedClassNum,
                right: request.currentClassNum,
              ),
            ),
            const SizedBox(height: 10),
            Text(context.getString("swaped_action_msg")),
            ContactField(
              ContactInputController(request.contactInfo),
              editable: false,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(context.getString('finish')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
