import 'package:flutter/material.dart';

class UserBannedPage extends StatelessWidget {
  final int studentID;
  const UserBannedPage(this.studentID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'The user($studentID) has been banned.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
