import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: ListView(
        children: [
          ListTile(
            title: const Text("Black Theme"),
            trailing: Consumer<ThemeProvider>(
              builder: (_, tProvider, __) => Switch(
                value: tProvider.isBlackTheme,
                onChanged: (b) => tProvider.setTheme(b),
              ),
            ),
          )
        ],
      ),
    );
  }
}
