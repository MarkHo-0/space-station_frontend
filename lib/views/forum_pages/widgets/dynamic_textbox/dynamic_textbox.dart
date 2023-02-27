import 'dart:convert';
import 'package:flutter/material.dart';

import 'elements/quote_block.dart';
import 'elements/headline.dart';
import 'elements/normal_text.dart';
import 'elements/math_block.dart';
import 'elements/code_block.dart';
import 'elements/base.dart';

class DynamicTextBox extends StatelessWidget {
  final String text;
  const DynamicTextBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 10,
      );
    }

    final List<String> lines = const LineSplitter().convert(text);
    final elements = parse(lines);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: elements.map((e) {
        final rawLines = lines.sublist(e.startLine, e.endLine + 1).toList();
        return e.type.build(context, rawLines);
      }).toList(),
    );
  }

  List<MatchedElement> parse(List<String> lines) {
    if (lines.isEmpty) return [];

    final List<MatchedElement> elements = [];
    int currLine = 0;
    int lastElementEndLine = -1;

    while (currLine < lines.length) {
      for (final element in specialElements) {
        //如果沒有匹配的首行，則配對下一個元素
        if (!element.isFirstLine(lines[currLine])) continue;

        bool matched = false;
        int endLine = currLine;

        //逐行檢查，直到匹配到元素的尾行
        if (element.isOneLine) {
          matched = true;
        } else {
          //如果往後剩餘的行數不足兩行，則表示沒有可能有內容
          endLine += 2;
          if (endLine >= lines.length) continue;

          //往後尋找完結標示，如果到最後一行都找不到，則匹配失敗
          for (; endLine < lines.length; endLine++) {
            if (element.isLastLine(lines[endLine])) {
              matched = true;
              break;
            }
          }
        }

        if (matched == false) continue;

        //檢查和上個成功匹配元素之間是否有空隙
        //如有則將空隙的內容先設為普通文字元素
        final possibleStartLine = lastElementEndLine + 1;
        if (possibleStartLine != currLine) {
          final textEndLine = currLine - 1;
          elements.add(MatchedElement(
            possibleStartLine,
            textEndLine,
            normalText,
          ));
        }

        //將匹配到的內容儲存
        elements.add(MatchedElement(currLine, endLine, element));
        lastElementEndLine = endLine;
        currLine = endLine;

        break;
      }
      currLine++;
    }

    //如有剩下行數，則全部轉為普通文字
    final possibleStartLine = lastElementEndLine + 1;
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

class MatchedElement {
  final int startLine;
  final int endLine;
  final ContentElement type;

  MatchedElement(this.startLine, this.endLine, this.type);
}

final List<ContentElement> specialElements = [
  Headline(),
  QuoteBlock(),
  CodeBlock(),
  MathBlock(),
];

final normalText = NormalText();
