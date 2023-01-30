import 'package:flutter/material.dart';
import 'package:space_station/api/interfaces/forum_api.dart' show getHomeData;
import 'package:space_station/models/thread.dart' show HomePageModel;
import 'package:space_station/views/_share/loading_page.dart';
import 'package:space_station/views/home_pages/widgets/hotest_thread_list.dart';
import 'package:space_station/views/home_pages/widgets/news_row.dart';
import 'package:space_station/views/home_pages/widgets/wellcome_box.dart';

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
    return FutureBuilder(
      future: getHomeData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error!');
          }

          HomePageModel data = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                const WellcomeBox(),
                NewsRow(data.newsArray),
                HotestThreadList(data.threadsArray),
              ],
            ),
          );
        }

        return const LoadingPage();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
