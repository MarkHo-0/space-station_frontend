import 'package:flutter/material.dart';

import 'base.dart';

class QuoteBlock implements ContentElement {
  final detector = RegExp(r'^>\s([^\s][^#]*)$');
  @override
  bool isFirstLine(String line) => detector.hasMatch(line);

  @override
  bool isLastLine(String line) => true;

  @override
  Widget build(BuildContext context, List<String> lines) {
    final source = detector.firstMatch(lines[0])!.group(1)!;
    final myTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: myTheme.highlightColor,
            border: Border(
              left: BorderSide(
                color: myTheme.dividerColor,
                width: 3,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SelectableText(
              source,
              textAlign: TextAlign.left,
              style: myTheme.textTheme.bodyMedium!.copyWith(
                color: myTheme.hintColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get isOneLine => true;
}
