import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/_share/loading_page.dart';

import '../../api/interfaces/other_api.dart';
import '../../api/error.dart';
import '../_share/network_error_page.dart';

class ToolboxPage extends StatefulWidget {
  const ToolboxPage({super.key});

  @override
  State<ToolboxPage> createState() => _ToolboxPageState();
}

class _ToolboxPageState extends State<ToolboxPage>
    with AutomaticKeepAliveClientMixin<ToolboxPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: getToolboxAvailabilities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }

        if (snapshot.hasError) {
          if (snapshot.error is NetworkError) {
            return const NetworkErrorPage();
          }
          return const SizedBox();
        }

        final stauts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  context.getString("toolbox_page"),
                  style: Theme.of(context).textTheme.headlineMedium,
                  softWrap: false,
                ),
              ),
              ToolboxItem(
                nameKey: "class_swapping",
                descriptionKey: "class_swapping_description",
                backgroundImagePath: "assets/images/bookshelf.jpg",
                enabled: stauts.classSwapping,
              ),
              ToolboxItem(
                nameKey: "study_parner",
                descriptionKey: "study_parner_description",
                backgroundImagePath: "assets/images/discuss.jpg",
                enabled: stauts.studyParner,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ToolboxItem extends StatelessWidget {
  final String nameKey;
  final String descriptionKey;
  final String backgroundImagePath;
  final Widget? page;
  final bool enabled;
  const ToolboxItem({
    super.key,
    required this.nameKey,
    required this.descriptionKey,
    required this.backgroundImagePath,
    this.enabled = true,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    if (enabled == false) return Container();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          if (page == null) return;
          Navigator.of(context).push(MaterialPageRoute(
            builder: ((_) => page!),
          ));
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.35),
                BlendMode.dstATop,
              ),
              image: AssetImage(backgroundImagePath),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.getString(nameKey),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                Text(
                  context.getString(descriptionKey),
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
