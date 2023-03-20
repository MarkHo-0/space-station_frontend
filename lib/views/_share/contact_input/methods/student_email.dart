import 'package:flutter/material.dart';
import 'package:space_station/providers/auth_provider.dart';
import 'base.dart';

const String _kEmailSufix = '@learner.hkuspace.hku.hk';

class ContactStudentEmail implements ContactDetail {
  @override
  Widget build(BuildContext ctx, FocusNode fNode, ValueNotifier<String> input) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(hintText: toDisplayText(input.value)),
    );
  }

  @override
  bool isEnable(BuildContext context) {
    return getLoginedUser(context) != null;
  }

  @override
  String toDisplayText(String data) {
    return '$data$_kEmailSufix';
  }
}
