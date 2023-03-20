import 'package:flutter/material.dart';

class TitledContainer extends StatelessWidget {
  final String title;
  final Widget body;
  const TitledContainer({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        body,
        const SizedBox(height: 10),
      ],
    );
  }
}

class TitledField extends StatelessWidget {
  final String title;
  final Widget body;
  const TitledField({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: body,
        ),
      ],
    );
  }
}
