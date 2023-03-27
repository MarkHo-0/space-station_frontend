import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:space_station/models/contact_info.dart';
import 'package:space_station/models/user.dart';
import 'package:space_station/providers/auth_provider.dart';

import 'methods.dart';

const _dataKey = 'contact';

class ContactField extends StatefulWidget {
  final bool editable;
  final ContactInputController controller;
  const ContactField(
    this.controller, {
    this.editable = true,
    super.key,
  });

  @override
  State<ContactField> createState() => _ContactFieldState();
}

class _ContactFieldState extends State<ContactField> {
  bool shouldSave = false;
  final inputNode = FocusNode();
  late ValueNotifier<String> detailInput;
  SharedPreferences? pref;
  UserInfo? currUser;
  @override
  void initState() {
    super.initState();
    detailInput = ValueNotifier(widget.controller.datail);
    if (widget.editable) {
      detailInput.addListener(onDetailUpdated);
      widget.controller.onSave(trySave);
      SharedPreferences.getInstance().then((saved) {
        pref = saved;
        currUser = getLoginedUser(context);
        if (widget.controller.value != null) return;
        loadDefalut();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isEmpty) {
      return buildLoadingContainer(context);
    }
    if (widget.editable == false) {
      return buildContactDisplayer(context);
    }
    return buildEditableContact(context);
  }

  Widget buildLoadingContainer(BuildContext context) {
    return Text(context.getString('loading_contact'));
  }

  Widget buildContactDisplayer(BuildContext context) {
    final methold = getMetholdName(context, widget.controller.method - 1);
    final detail = currMethod.detail.toDisplayText(widget.controller.datail);
    bool copied = false;
    return StatefulBuilder(
      builder: (BuildContext context, updateUI) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              child: InkWell(
                child: Text(
                  '$methold: $detail',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: detail)).then((_) {
                    copied = true;
                    updateUI(() {});
                  });
                },
              ),
            ),
            Visibility(
              visible: copied == true,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.content_copy,
                    color: Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(context.getString('copied_contct')),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildEditableContact(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: DropdownButtonFormField<int>(
                items: List.generate(
                  kMethods.length,
                  (i) => DropdownMenuItem(
                    value: i,
                    enabled: kMethods[i].detail.isEnable(context),
                    child: Text(getMetholdName(context, i)),
                  ),
                ),
                value: widget.controller.method - 1,
                onChanged: onMetholdChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: currMethod.detail.build(context, inputNode, detailInput),
            ),
          ],
        ),
        buildSaveCheckbox(context),
      ],
    );
  }

  Widget buildSaveCheckbox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          StatefulBuilder(
            builder: (BuildContext context, updateUI) {
              return Checkbox(
                value: shouldSave,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) => updateUI(() => shouldSave = value!),
              );
            },
          ),
          Text(context.getString('save_contact')),
        ],
      ),
    );
  }

  void onMetholdChanged(int? index) {
    if (index == null || widget.editable == false) return;
    widget.controller.method = index + 1;
    if (index == 0 && currUser != null) {
      detailInput.value = currUser!.sid.toString();
    } else {
      detailInput.value = '';
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputNode.requestFocus();
    });
  }

  void onDetailUpdated() {
    widget.controller.datail = detailInput.value;
  }

  void loadDefalut() async {
    if (pref == null) return;
    final data = pref!.getStringList(_dataKey);
    late ContactInfo contact;
    if (data != null && data.length == 2) {
      final methold = int.parse(data[0]);
      final detail = data[1];
      contact = ContactInfo(methold, detail);
      shouldSave = true;
    } else if (currUser != null) {
      contact = ContactInfo(1, currUser!.sid.toString());
    } else {
      contact = ContactInfo(2, '');
    }
    widget.controller.value = contact;
    detailInput.value = contact.detail;
    setState(() {});
  }

  void trySave() {
    if (widget.editable == false || widget.controller.isEmpty) return;
    if (shouldSave == true && pref != null) {
      final data = widget.controller.value!.toStringList();
      pref!.setStringList(_dataKey, data);
    } else {
      pref!.remove(_dataKey);
    }
  }

  ContactMethod get currMethod => kMethods[widget.controller.method - 1];

  @override
  void dispose() {
    detailInput.dispose();
    super.dispose();
  }
}

class ContactInputController extends ValueNotifier<ContactInfo?> {
  void Function()? _onSaveCallBack;

  ContactInputController(super._value);

  int get method => isEmpty ? 0 : value!.method;
  String get datail => isEmpty ? '' : value!.detail;
  bool get isEmpty => value == null;

  set method(int newMethod) {
    value = ContactInfo(newMethod, '');
  }

  set datail(String newDatail) {
    value = ContactInfo(method, newDatail);
  }

  void onSave(void Function() callback) {
    _onSaveCallBack = callback;
  }

  void trySaveToLocal() {
    if (_onSaveCallBack == null) return;
    _onSaveCallBack!();
  }
}
