import 'package:flutter/material.dart';

import 'base.dart';

class NormalText implements ContentElement {
  @override
  bool isFirstLine(String line) => true;

  @override
  bool isLastLine(String line) => true;

  @override
  Widget build(BuildContext context, List<String> lines) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: lines.map((line) {
        return Text(line, style: Theme.of(context).textTheme.bodyMedium);
      }).toList(),
    );
  }

  @override
  bool get isOneLine => false;
}
