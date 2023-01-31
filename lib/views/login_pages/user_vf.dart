import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:space_station/api/interfaces/user_api.dart';
import 'package:space_station/views/login_pages/user_register.dart';

class EmailVerificationPage extends StatefulWidget {
  final int studentID;

  const EmailVerificationPage(this.studentID, {super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late List<int> inputs;
  late GlobalKey<FormState> inputFormKey;
  @override
  void initState() {
    super.initState();
    inputs = List<int>.filled(4, 0, growable: false);
    inputFormKey = GlobalKey<FormState>();
    sendVfCode(widget.studentID).ignore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('page_regester'.i18n()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            Text(
              'send_email_title'.i18n(),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '${widget.studentID}@learner.hkuspace.hku.hk',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            buildCodeInput(context, 4),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => onSumbitVerificationCode(context),
              child: Text('next'.i18n()),
            )
          ],
        ),
      ),
    );
  }

  void onSumbitVerificationCode(BuildContext context) {
    final code = int.parse(inputs.join(''));
    if (code < 1000) {
      return inputFormKey.currentState!.reset();
    }
    checkVfCode(widget.studentID, code).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RegisterPage(widget.studentID),
        ),
      );
    }).onError((error, _) {
      inputFormKey.currentState!.reset();
    });
  }

  Widget buildCodeInput(BuildContext context, int length) {
    return Form(
      key: inputFormKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          length,
          growable: false,
          (index) => SizedBox(
            height: 68,
            width: 50,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyLarge,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              autofocus: index == 0,
              decoration: const InputDecoration(
                hintText: '0',
                isDense: false,
                contentPadding: EdgeInsets.all(0),
              ),
              enableInteractiveSelection: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                inputs[index] = int.tryParse(value) ?? 0;
                if (value.isEmpty) return;
                if (index == length - 1) {
                  FocusScope.of(context).unfocus();
                  onSumbitVerificationCode(context);
                } else {
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
