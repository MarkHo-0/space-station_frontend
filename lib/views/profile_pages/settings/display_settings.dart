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
          ListTile(
            title: Text(context.getString('black_theme')),
            trailing: Consumer<ThemeProvider>(
              builder: (_, tProvider, __) => Switch(
                value: tProvider.isBlackTheme,
                onChanged: (b) => tProvider.setTheme(b),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(context.getString('language')),
            trailing: DropdownButton<Locale>(
              value: EzLocalization.of(context)!.locale,
              items: kSupportedLocales
                  .map(
                    (l) => DropdownMenuItem(
                      value: l.locale,
                      child: Text(l.name),
                    ),
                  )
                  .toList(),
              onChanged: (l) {
                EzLocalizationBuilder.of(context)!.changeLocale(l);
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
