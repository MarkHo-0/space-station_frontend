import 'package:flutter/widgets.dart';

typedef ExtraData = Map<String, String>;

abstract class ContentElement {
  final bool isOneLine = false;

  bool isFirstLine(String line);

  bool isLastLine(String line);

  Widget build(BuildContext context, List<String> lines);
}
