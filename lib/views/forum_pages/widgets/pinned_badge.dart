import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

class PinnedBadge extends StatefulWidget {
  final int myCommentID;
  final ValueNotifier<int?> pinned;
  final bool updatable;
  const PinnedBadge(this.myCommentID, this.pinned, this.updatable, {super.key});
  @override
  State<PinnedBadge> createState() => _PinnedBadgeState();
}

class _PinnedBadgeState extends State<PinnedBadge> {
  @override
  void initState() {
    if (widget.updatable) {
      widget.pinned.addListener(onPinChanged);
    }
    super.initState();
  }

  void onPinChanged() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.myCommentID == widget.pinned.value,
      child: Text(
        context.getString("comment_pinned"),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.updatable) {
      widget.pinned.removeListener(onPinChanged);
    }
    super.dispose();
  }
}
