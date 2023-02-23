import 'package:flutter/material.dart';

import 'base.dart';

class NormalText implements ContentElement {
  @override
  bool isFirstLine(String line) => true;

  @override
  bool isLastLine(String line) => true;

  @override
  Widget build(BuildContext context, List<String> lines) {
    return SelectableText(
      lines.join('\n'),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  @override
  bool get isOneLine => false;
}
