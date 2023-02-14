import 'package:flutter/material.dart';
import 'package:space_station/api/error.dart';
import 'package:space_station/utils/parse_time.dart';
import 'package:space_station/views/_share/loading_page.dart';
import 'package:space_station/views/_share/network_error_page.dart';

const _kRefreshMinInterval = 3;

class FuturePage<T> extends StatefulWidget {
  final Future<T> Function() future;
  final Widget Function(BuildContext, T) builder;
  const FuturePage({super.key, required this.future, required this.builder});

  @override
  State<FuturePage<T>> createState() => _FuturePageState<T>();
}

class _FuturePageState<T> extends State<FuturePage<T>> {
  T? pageData;
  Object? error;
  int lastRefreshOn = 0;

  @override
  void initState() {
    super.initState();
    tryLoad();
  }

  @override
  Widget build(BuildContext context) {
    if (error == null && pageData == null) {
      return const LoadingPage();
    }

    return RefreshIndicator(
      onRefresh: tryLoad,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          constraints: getMinConstraint(context),
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    if (pageData != null) {
      return widget.builder(context, pageData as T);
    }

    if (error is NetworkError) {
      return const NetworkErrorPage();
    }

    return buildUnknowErrorPage(context);
  }

  Future<void> tryLoad() async {
    if (getCurrUnixTime() - lastRefreshOn < _kRefreshMinInterval) {
      showTooFrequentToast();
      return Future.value();
    }
    error = null;

    return widget.future().then((result) {
      pageData = result;
      lastRefreshOn = getCurrUnixTime();
    }).onError((e, _) {
      error = e;
      if (pageData != null) showLoadFailedToast();
    }).whenComplete(() {
      setState(() {});
      return Future.value();
    });
  }

  void showTooFrequentToast() {
    //TODO: 加入 Toast 提醒
  }

  void showLoadFailedToast() {
    //TODO: 加入 Toast 提醒
  }

  Widget buildUnknowErrorPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Theme.of(context).primaryColor,
            size: 100,
          ),
          Text(
            "Unknown Error",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  BoxConstraints getMinConstraint(BuildContext context) {
    final mq = MediaQuery.of(context);
    const navHeight = kBottomNavigationBarHeight;
    final myHeight = mq.size.height - navHeight - mq.viewPadding.top;
    return BoxConstraints(minHeight: myHeight, minWidth: mq.size.width);
  }
}
