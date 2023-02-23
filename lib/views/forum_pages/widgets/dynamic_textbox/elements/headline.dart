import 'package:flutter/material.dart';

import 'base.dart';

class Headline implements ContentElement {
  final detector = RegExp(r'^(#{1,3})\s([^\s][^#]*)$');
  @override
  bool isFirstLine(String line) => detector.hasMatch(line);

  @override
  bool isLastLine(String line) => true;

  @override
  Widget build(BuildContext context, List<String> lines) {
    final matched = detector.firstMatch(lines[0])!;
    final level = matched.group(1)!.length;
    final line = matched.group(2)!;

    final styles = Theme.of(context).textTheme;
    late TextStyle finalSyle;
    if (level == 1) finalSyle = styles.headlineMedium!;
    if (level == 2) finalSyle = styles.titleLarge!;
    if (level == 3) finalSyle = styles.titleMedium!;

    return SelectableText(line, style: finalSyle);
  }

  @override
  bool get isOneLine => true;
}
