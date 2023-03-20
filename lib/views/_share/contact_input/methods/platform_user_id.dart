import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base.dart';

final userIDValidator = RegExp(r'^[a-zA-Z0-9_]{2,100}$');

class ContactPlatformUserID implements ContactDetail {
  @override
  Widget build(BuildContext ctx, FocusNode fNode, ValueNotifier<String> input) {
    return TextFormField(
      initialValue: input.value,
      focusNode: fNode,
      decoration: InputDecoration(
        hintText: ctx.getString('c_methold_account_hint'),
      ),
      keyboardType: TextInputType.name,
      inputFormatters: [LengthLimitingTextInputFormatter(20)],
      onChanged: (value) => input.value = value,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !userIDValidator.hasMatch(value)) {
          return ctx.getString('c_methold_account_invalid');
        }
        return null;
      },
    );
  }

  @override
  bool isEnable(BuildContext context) => true;

  @override
  String toDisplayText(String data) => '@$data';
}
