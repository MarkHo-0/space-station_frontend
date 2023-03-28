import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/models/course.dart';
import 'package:space_station/views/toolbox_pages/class_matching/widget/class_exchange_view.dart';

import '../../../api/interfaces/toolbox_api.dart';
import '../../_share/unknown_error_popup.dart';
import 'create_request.dart';
import '../../../models/courseswap.dart';
import 'contactpage.dart';

class SearchSwapPage extends StatefulWidget {
  final int searchClass;
  final CourseInfo searchCourse;
  final List<SearchRequest> result;
  const SearchSwapPage({
    super.key,
    required this.searchClass,
    required this.searchCourse,
    required this.result,
  });

  @override
  State<SearchSwapPage> createState() => SearchSwapPageState();
}

class SearchSwapPageState extends State<SearchSwapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.getString("found_time_slots"))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.searchCourse.coureseName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            buildResult(context),
            buildFooter(context)
          ],
        ),
      ),
    );
  }

  Widget buildResult(BuildContext context) {
    if (widget.result.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          context.getString("no_time_slots"),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      );
    }

    return Column(
      children: List.generate(widget.result.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: buildResultItem(context, index),
        );
      }),
    );
  }

  Widget buildResultItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.getString("given_out")),
              Text(
                "CL${widget.result[index].classNum.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () => performSwap(index),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
            ),
            child: Text(context.getString("swap")),
          )
        ],
      ),
    );
  }

  void performSwap(int index) {
    showConfirmation(context, index, () {
      swapRequest(widget.result[index].id).then((request) {
        return Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: ((_) {
            return ContactPage(request);
          })),
        );
      }).onError((e, __) => showUnkownErrorDialog(context));
    });
  }

  Widget buildFooter(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            context.getString("create_swap_hint"),
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: ((_) {
                  return SwapCreatePage(
                    currentClass: widget.searchClass,
                    targetCourse: widget.searchCourse,
                  );
                }),
              ));
            },
            child: Text(context.getString("create_swap")),
          ),
        ],
      ),
    );
  }

  void showConfirmation(BuildContext pageCtx, int index, VoidCallback runner) {
    final courseName = widget.searchCourse.coureseName;
    final currClass = widget.searchClass;
    final expClass = widget.result[index].classNum;
    showDialog<void>(
      context: pageCtx,
      builder: (dialogCtx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              courseName,
              style: Theme.of(pageCtx).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ClassExchangeView(left: currClass, right: expClass),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              runner();
            },
            child: Text(pageCtx.getString("conform")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              pageCtx.getString("cancel"),
              style: TextStyle(color: Theme.of(pageCtx).disabledColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
