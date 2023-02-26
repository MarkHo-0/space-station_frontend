import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

class PostActionDialog extends StatefulWidget {
  final Future<int> Function() onPost;

  const PostActionDialog(this.onPost, {super.key});

  @override
  State<PostActionDialog> createState() => _PostActionDialogState();
}

class _PostActionDialogState extends State<PostActionDialog> {
  bool isPosting = false;
  bool isPosted = false;
  bool isFailed = false;
  int? returnID;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBody(context),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: buildActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium!;

    if (!isPosted && !isFailed) {
      return Text(
        context.getString("before_post_confirm"),
        style: titleStyle,
      );
    }
    if (isFailed) {
      return Text(
        context.getString("post_faild"),
        style: titleStyle.copyWith(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
        const SizedBox(width: 5),
        Text(context.getString("post_success"), style: titleStyle),
      ],
    );
  }

  List<Widget> buildActions(BuildContext context) {
    final secondStyle = TextStyle(
      color: Theme.of(context).disabledColor,
    );
    if (!isPosted) {
      return [
        TextButton(
          onPressed: isPosting ? null : () => performPost(context),
          child: Text(context.getString(isFailed ? "retry" : "conform")),
        ),
        TextButton(
          onPressed: isPosting ? null : () => Navigator.pop(context),
          child: Text(
            context.getString("cancel"),
            style: secondStyle,
          ),
        )
      ];
    }
    return [
      TextButton(
        onPressed: () => Navigator.pop(context, returnID),
        child: Text(
          context.getString("view_posted"),
          style: secondStyle,
        ),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, 0),
        child: Text(context.getString("finish")),
      )
    ];
  }

  void performPost(BuildContext context) {
    if (isPosting || isPosted) return;
    isFailed = false;
    setState(() => isPosting = true);
    widget.onPost().then((id) {
      isPosted = true;
      returnID = id;
    }).catchError((err) {
      isFailed = true;
    }).whenComplete(() {
      setState(() => isPosting = false);
    });
  }
}
