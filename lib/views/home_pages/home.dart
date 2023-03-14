import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/interfaces/forum_api.dart' show getHomeData;
import '../../providers/auth_provider.dart';
import '../_share/future_page.dart';
import 'widgets/hotest_thread_list.dart';
import 'widgets/news_row.dart';
import 'widgets/welcome_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FuturePage(
      future: getHomeData,
      builder: (context, data) {
        //檢查當前本地的登入訊息是否還有效，如沒則刪除
        final currAuth = Provider.of<AuthProvider>(context, listen: false);
        if (currAuth.isLogined && data.user == null) {
          currAuth.clearLoginData();
        }

        return Column(
          children: [
            WelcomeBox(),
            if (data.newsArray.isNotEmpty) NewsRow(data.newsArray),
            HotestThreadList(data.threadsArray),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
