import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/profile_pages/widgets/next_page_tile.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getString("account_settings")),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          const Divider(),
          NextPageTile(title: context.getString("nickname_setting")),
          const Divider(),
          NextPageTile(title: context.getString("faculty_setting")),
          const Divider(),
          NextPageTile(title: context.getString("password_setting")),
          const Divider(),
        ],
      ),
    );
  }
}
