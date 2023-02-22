import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atelier-cave-dark.dart';
import 'package:flutter_highlight/themes/atelier-cave-light.dart';

import 'base.dart';

final lineStartReg = RegExp(r'^```([a-z_]{1,15})$');
final lineEndReg = RegExp(r'^```$');

class CodeBlock implements ContentElement {
  @override
  bool isFirstLine(String line) => lineStartReg.hasMatch(line);

  @override
  bool isLastLine(String line) => lineEndReg.hasMatch(line);

  @override
  Widget build(BuildContext context, List<String> lines) {
    final codeLanguage = lineStartReg.firstMatch(lines[0])!.group(1);
    final codeTheme = Theme.of(context).brightness == Brightness.light
        ? atelierCaveLightTheme
        : atelierCaveDarkTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: codeTheme['root']!.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            HighlightView(
              lines.sublist(1, lines.length - 1).join('\n'),
              language: codeLanguage,
              theme: codeTheme,
              padding: const EdgeInsets.all(10),
              tabSize: 2,
              textStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 10, top: 5),
              child: Text(
                codeLanguage!,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  color: codeTheme['comment']!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get isOneLine => false;
}
