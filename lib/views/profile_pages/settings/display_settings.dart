import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../utils/locals.dart';

class DisplaySettingsPage extends StatelessWidget {
  const DisplaySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getString('display_settings')),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          const Divider(),
          buildThemeOption(context),
          const Divider(),
          buildLanguageOption(context),
          const Divider(),
        ],
      ),
    );
  }

  Widget buildThemeOption(BuildContext context) {
    return ListTile(
      title: Text(context.getString('black_theme')),
      trailing: Consumer<ThemeProvider>(
        builder: (_, tProvider, __) => Switch(
          value: tProvider.isBlackTheme,
          onChanged: (b) => tProvider.setTheme(b),
        ),
      ),
    );
  }

  Widget buildLanguageOption(BuildContext context) {
    return ListTile(
      title: Text(context.getString('language')),
      trailing: DropdownButton<Locale>(
        value: EzLocalization.of(context)!.locale,
        items: kSupportedLanguages.map((l) {
          return DropdownMenuItem(value: l.locale, child: Text(l.name));
        }).toList(),
        onChanged: (locale) {
          if (locale == null) return;
          saveLocale(locale);
          EzLocalizationBuilder.of(context)!.changeLocale(locale);
        },
      ),
    );
  }
}
