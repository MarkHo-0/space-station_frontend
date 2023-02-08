import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/theme_provider.dart';
import 'package:space_station/utils/locals.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: ListView(
        children: [
          ListTile(
            title: Text(context.getString('black_theme')),
            trailing: Consumer<ThemeProvider>(
              builder: (_, tProvider, __) => Switch(
                value: tProvider.isBlackTheme,
                onChanged: (b) => tProvider.setTheme(b),
              ),
            ),
          ),
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
                  }))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
