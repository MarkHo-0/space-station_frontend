import 'dart:convert';
import 'package:flutter/material.dart';

import 'elements/base.dart';
import 'elements/normal_text.dart';
import 'elements/math_block.dart';
import 'elements/code_block.dart';

class DynamicTextBox extends StatelessWidget {
  final String text;
  const DynamicTextBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const Text('Empty');
    }

    final List<String> lines = const LineSplitter().convert(text);
    final elements = parse(lines);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: elements.map((e) {
          final rawLines = lines.sublist(e.startLine, e.endLine + 1).toList();
          return e.type.build(context, rawLines);
        }).toList(),
      ),
    );
  }

  List<MatchedElement> parse(List<String> lines) {
    if (lines.isEmpty) return [];

    final List<MatchedElement> elements = [];
    int currLine = 0;
    int lastElementEndLine = 0;

    while (currLine < lines.length) {
      for (final element in specialElements) {
        //如果沒有匹配的首行，則配對下一個元素
        if (!element.isFirstLine(lines[currLine])) continue;

        //如果元素屬於一行，則完成匹配
        if (element.isOneLine) {
          elements.add(MatchedElement(currLine, currLine, element));
          lastElementEndLine++;
          break;
        }

        //如果往後剩餘的行數不足兩行，則表示沒有可能有內容
        if (currLine + 2 >= lines.length) break;

        //往後尋找完結標示，如果到最後一行都找不到，則匹配失敗
        bool matched = false;
        int endLine = currLine + 2;
        for (; endLine < lines.length; endLine++) {
          if (element.isLastLine(lines[endLine])) {
            matched = true;
            break;
          }
        }
        if (matched == false) continue;

        //檢查和上個成功匹配元素之間是否有空隙
        //如有則將空隙的內容先設為普通文字元素
        final possibleStartLine = addOneIfNonZero(lastElementEndLine);
        if (possibleStartLine != currLine) {
          final textEndLine = currLine - 1;
          elements.add(MatchedElement(
            possibleStartLine,
            textEndLine,
            normalText,
          ));
        }

        //儲存匹配到的所有行數和其元素類型
        elements.add(MatchedElement(currLine, endLine, element));
        lastElementEndLine = endLine;
        currLine = endLine;
        break;
      }
      currLine++;
    }

    //如有剩下行數，則全部轉為普通文字
    final possibleStartLine = addOneIfNonZero(lastElementEndLine);
    if (possibleStartLine < lines.length) {
      elements.add(MatchedElement(
        possibleStartLine,
        lines.length - 1,
        normalText,
      ));
    }

    return elements;
  }
}

int addOneIfNonZero(int value) {
  if (value == 0) return 0;
  return value + 1;
}

class MatchedElement {
  final int startLine;
  final int endLine;
  final ContentElement type;

  MatchedElement(this.startLine, this.endLine, this.type);
}

final List<ContentElement> specialElements = [
  CodeBlock(),
  MathBlock(),
];

final normalText = NormalText();
