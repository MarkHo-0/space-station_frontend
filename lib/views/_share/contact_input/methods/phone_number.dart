import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base.dart';

class ContactPhoneNumber implements ContactDetail {
  @override
  Widget build(BuildContext ctx, FocusNode fNode, ValueNotifier<String> input) {
    final phoneInput = TextEditingController();
    late PhoneNumberPatten selectedPatten;

    final data = input.value.split(' ');
    if (data.length == 2) {
      selectedPatten = kPhonePattens.firstWhere(
        (p) => p.areaCode == data[0],
        orElse: () => kPhonePattens.first,
      );
      phoneInput.text = data[1];
    } else {
      selectedPatten = kPhonePattens.first;
    }

    phoneInput.addListener(() {
      input.value = '${selectedPatten.areaCode} ${phoneInput.text}';
    });

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: DropdownButtonFormField(
                value: selectedPatten,
                items: kPhonePattens.map((patten) {
                  return DropdownMenuItem(
                    value: patten,
                    child: Text(patten.areaCode),
                  );
                }).toList(),
                onChanged: (p) => setState(() {
                  input.value = '';
                  selectedPatten = p!;
                  fNode.requestFocus();
                }),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                controller: phoneInput,
                decoration: InputDecoration(
                  hintText: context.getString('c_methold_whatsapp_hint'),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                focusNode: fNode,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !selectedPatten.validator.hasMatch(value)) {
                    return context.getString('c_methold_whatsapp_invalid');
                  }
                  return null;
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  String toDisplayText(String data) => data;

  @override
  bool isEnable(BuildContext context) => true;
}

final kPhonePattens = [
  PhoneNumberPatten('+852', RegExp(r'^[2-9][0-9]{7}$')),
  PhoneNumberPatten('+886', RegExp(r'^9[0-9]{8}$')),
  PhoneNumberPatten('+86', RegExp(r'^[1-8][0-9]{9,10}$')),
];

class PhoneNumberPatten {
  final String areaCode;
  final RegExp validator;
  const PhoneNumberPatten(this.areaCode, this.validator);
}
