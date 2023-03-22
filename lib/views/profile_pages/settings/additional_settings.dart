import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/profile_pages/widgets/legal_doc_page.dart';
import 'package:space_station/views/profile_pages/widgets/next_page_tile.dart';
import 'package:space_station/views/profile_pages/widgets/setting_subtitle.dart';

class AdditionalSettingsPage extends StatelessWidget {
  const AdditionalSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getString("additional_settings")),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          const Divider(),
          NextPageTile(title: context.getString("crash_report")),
          const Divider(),
          SettingSubtitle(context.getString("subtitle_legal")),
          const Divider(),
          NextPageTile(
            title: context.getString("terms_of_service"),
            nextPage: const LegalDocPage('terms_of_service'),
          ),
          const Divider(),
          NextPageTile(
            title: context.getString("privacy_policy"),
            nextPage: const LegalDocPage('privacy_policy'),
          ),
          const Divider(),
          NextPageTile(
            title: context.getString("cookies_usage"),
            nextPage: const LegalDocPage('cookies_usage'),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
