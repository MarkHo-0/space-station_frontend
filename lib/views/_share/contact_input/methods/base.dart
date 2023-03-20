import 'package:flutter/material.dart';

abstract class ContactDetail {
  Widget build(BuildContext ctx, FocusNode fNode, ValueNotifier<String> input);

  String toDisplayText(String data);

  bool isEnable(BuildContext context);
}
