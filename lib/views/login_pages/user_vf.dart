import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailVerificationPage extends StatelessWidget {
  final int studentID;
  final inputs = List<int>.filled(4, 0, growable: false);
  final inputFormKey = GlobalKey<FormState>();
  EmailVerificationPage(this.studentID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            const Text(
              'We have sent you a verification code to the following email:',
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '$studentID@learner.hkuspace.hku.hk',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            buildCodeInput(context, 4),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text('Next'),
            )
          ],
        ),
      ),
    );
  }

  void sendVerificationCode() {
    //TODO
  }

  void onSumbitVerificationCode() {
    //TODO
    inputFormKey.currentState!.reset();
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
                  onSumbitVerificationCode();
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
