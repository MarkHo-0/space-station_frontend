import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/localization_provider.dart';
import 'package:space_station/providers/theme_provider.dart';

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
            title: Text('black_theme'.i18n()),
            trailing: Consumer<ThemeProvider>(
              builder: (_, tProvider, __) => Switch(
                value: tProvider.isBlackTheme,
                onChanged: (b) => tProvider.setTheme(b),
              ),
            ),
          ),
          ListTile(
            title: Text('language'.i18n()),
            trailing: Consumer<LanguageProvider>(
                builder: ((_, langProvider, __) => DropdownButton<Language>(
                      items: langProvider.supportedLanguages
                          .map((lang) => DropdownMenuItem<Language>(
                                value: lang,
                                child: Text(lang.name),
                              ))
                          .toList(),
                      value: langProvider.currLanguage,
                      onChanged: (newLang) {
                        langProvider.updateLanguage(newLang!);
                      },
                    ))),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
