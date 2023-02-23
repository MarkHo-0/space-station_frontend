import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import 'base.dart';

class MathBlock implements ContentElement {
  final RegExp sign = RegExp(r'^\$\$$');

  @override
  bool isFirstLine(String line) => sign.hasMatch(line);

  @override
  bool isLastLine(String line) => sign.hasMatch(line);

  @override
  Widget build(BuildContext context, List<String> lines) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: lines.getRange(1, lines.length - 1).map((singleLineMath) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Math.tex(
              singleLineMath,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  bool get isOneLine => false;
}
