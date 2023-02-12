import 'package:flutter/material.dart';

const kFillerText = "-";

class StatsCounter extends StatelessWidget {
  final int? quantity;
  final String name;
  final VoidCallback onTap;
  const StatsCounter({
    super.key,
    this.quantity,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return InkWell(
      onTap: quantity == null ? null : onTap,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quantity == null ? kFillerText : quantity.toString(),
              style: textStyle,
            ),
            Text(name, style: textStyle),
          ],
        ),
      ),
    );
  }
}
