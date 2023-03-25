import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/toolbox_pages/class_matching/lobby.dart';
import 'package:space_station/views/toolbox_pages/study_partner/lobby.dart';
import '../../providers/auth_provider.dart';
import '../_share/future_page.dart';
import '../../api/interfaces/other_api.dart';

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

    return FuturePage(
      future: getToolboxAvailabilities,
      builder: (context, stauts) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                backgroundImagePath: "assets/images/bookshelf.jpg",
                enabled: stauts.classSwapping,
                page: const CMlobbyPage(),
              ),
              ToolboxItem(
                nameKey: "study_parner",
                backgroundImagePath: "assets/images/discuss.jpg",
                enabled: stauts.studyParner,
                page: const StudyPartnerLobbyPage(),
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
  final String backgroundImagePath;
  final Widget? page;
  final bool enabled;
  const ToolboxItem({
    super.key,
    required this.nameKey,
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
          if (getLoginedUser(context, warnOnEmpty: true) == null) return;
          Navigator.of(context).push(MaterialPageRoute(
            builder: ((_) => page!),
          ));
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
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
                  context.getString("${nameKey}_description"),
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
