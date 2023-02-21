import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api/error.dart';
import '../../api/interfaces/user_api.dart';
import '../_share/loadable_button.dart';
import '../_share/unknown_error_popup.dart';
import './user_register.dart';

class EmailVerificationPage extends StatefulWidget {
  final int studentID;

  const EmailVerificationPage(this.studentID, {super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final inputs = List<int>.filled(4, 0, growable: false);
  final inputFormKey = GlobalKey<FormState>();
  final firstDigitFocus = FocusNode();

  bool isLoading = true;
  bool isSendFailed = false;
  bool isCodeValid = true;

  @override
  void initState() {
    super.initState();
    sendVfCode(widget.studentID).catchError((e) {
      isSendFailed = true;
      return false;
    }).whenComplete(() {
      setState(() => isLoading = false);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => firstDigitFocus.requestFocus(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.getString('page_register')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            Text(
              context.getString('send_email_title'),
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
            if (!isCodeValid) buildInvalidText(context),
            const SizedBox(height: 40),
            LoadableButton(
              text: context.getString('conform'),
              isLoading: isLoading,
              onPressed: () => onSumbitCode(context),
            )
          ],
        ),
      ),
    );
  }

  void onSumbitCode(BuildContext context) {
    final code = int.parse(inputs.join(''));
    //所有驗證碼一定大於1000
    if (code < 1000) return onCodeIsInvalid();

    setState(() => isLoading = true);

    checkVfCode(widget.studentID, code).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RegisterPage(widget.studentID),
        ),
      );
    }).onError((err, _) {
      if (err is GeneralError) {
        onCodeIsInvalid();
      } else {
        showUnkownErrorDialog(context);
      }
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }

  void onCodeIsInvalid() {
    setState(() => isCodeValid = false);
    inputFormKey.currentState!.reset();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => firstDigitFocus.requestFocus(),
    );
  }

  Widget buildInvalidText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          context.getString('field_vfcode_invlid'),
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.red),
        ),
      ),
    );
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
            width: 50,
            child: TextFormField(
              enabled: !isLoading,
              style: Theme.of(context).textTheme.bodyLarge,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              focusNode: index == 0 ? firstDigitFocus : null,
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
                  onSumbitCode(context);
                } else {
                  if (!isCodeValid) setState(() => isCodeValid = true);
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
