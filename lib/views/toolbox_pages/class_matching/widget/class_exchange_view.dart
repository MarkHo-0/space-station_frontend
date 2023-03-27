import 'package:flutter/material.dart';

class ClassExchangeView extends StatelessWidget {
  final int left;
  final int right;
  const ClassExchangeView({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "CL${left.toString().padLeft(2, '0')}",
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.arrow_forward, size: 18),
        ),
        Text(
          "CL${right.toString().padLeft(2, '0')}",
          style: Theme.of(context).textTheme.titleMedium!,
        )
      ],
    );
  }
}
