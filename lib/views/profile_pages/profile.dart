import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/auth_provider.dart';
import 'package:space_station/views/profile_pages/widgets/logout_button.dart';
import 'package:space_station/views/profile_pages/widgets/user_info_box.dart';

import 'settings/setting_lobby.dart';

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

    final islogined = Provider.of<AuthProvider>(context).isLogined;
    return ListView(
      children: [
        const UserInfoBox(),
        const SettingContainer(),
        const SizedBox(height: 80),
        Visibility(
          visible: islogined,
          child: const LogoutButton(),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
