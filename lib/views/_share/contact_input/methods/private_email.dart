import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base.dart';

final emailValidator = RegExp(r'^[\w-\.]{2,80}@([\w-]{2,6}\.)+[\w-]{2,4}$');

class ContactPrivateEmail implements ContactDetail {
  @override
  Widget build(BuildContext ctx, FocusNode fNode, ValueNotifier<String> input) {
    return TextFormField(
      focusNode: fNode,
      initialValue: input.value,
      decoration: InputDecoration(
        hintText: ctx.getString('c_methold_private_email_hint'),
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(70)],
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => input.value = value,
      validator: (value) {
        if (!isEmail(value)) {
          return ctx.getString('c_methold_private_email_invalid');
        }
        return null;
      },
    );
  }

  bool isEmail(String? text) {
    return text != null && text.isNotEmpty && emailValidator.hasMatch(text);
  }

  @override
  bool isEnable(BuildContext context) => true;

  @override
  String toDisplayText(String data) => data;
}
