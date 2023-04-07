import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/next_page_tile.dart';
import '../widgets/setting_subtitle.dart';
import 'additional_settings.dart';
import 'display_settings.dart';
import 'notification_settings.dart';
import 'account_settings.dart';

class SettingContainer extends StatelessWidget {
  const SettingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final isLogined = getLoginedUser(context, listen: true) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingSubtitle(context.getString("settings")),
        if (isLogined) const Divider(),
        if (isLogined)
          NextPageTile(
            title: context.getString("account_settings"),
            leadingIcon: Icons.person_outline,
            nextPage: const AccountSettingsPage(),
          ),
        const Divider(),
        NextPageTile(
          title: context.getString("display_settings"),
          leadingIcon: Icons.phone_iphone,
          nextPage: const DisplaySettingsPage(),
        ),
        const Divider(),
        NextPageTile(
          title: context.getString("notification_settings"),
          leadingIcon: Icons.notifications_on_outlined,
          nextPage: const NotificationSettingsPage(),
        ),
        const Divider(),
        NextPageTile(
          title: context.getString("additional_settings"),
          leadingIcon: Icons.more_outlined,
          nextPage: const AdditionalSettingsPage(),
        ),
        const Divider(),
      ],
    );
  }
}
