import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getString('notification_settings')),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          const Divider(),
          buildNotificationTile(context, "recieved_like"),
          const Divider(),
          buildNotificationTile(context, "recieved_comment"),
          const Divider(),
          buildNotificationTile(context, "toolbox_updated"),
          const Divider(),
        ],
      ),
    );
  }

  Widget buildNotificationTile(BuildContext context, String titleKey) {
    bool tempBool = true;
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
        title: Text(context.getString(titleKey)),
        trailing: Switch(
          value: tempBool,
          onChanged: (value) => setState(() => tempBool = value),
        ),
      );
    });
  }
}
