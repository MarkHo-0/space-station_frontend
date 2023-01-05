import 'package:flutter/widgets.dart';

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
