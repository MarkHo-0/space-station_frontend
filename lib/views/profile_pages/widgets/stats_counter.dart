import 'package:flutter/material.dart';

class StatsCounter extends StatefulWidget {
  final ValueNotifier<int> quantity;
  final String name;
  final VoidCallback onTap;
  const StatsCounter({
    super.key,
    required this.quantity,
    required this.name,
    required this.onTap,
  });

  @override
  State<StatsCounter> createState() => _StatsCounterState();
}

class _StatsCounterState extends State<StatsCounter> {
  @override
  void initState() {
    super.initState();
    widget.quantity.addListener(onValueUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.quantity.value.toString(),
              style: textStyle,
            ),
            Text(widget.name, style: textStyle),
          ],
        ),
      ),
    );
  }

  void onValueUpdated() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.quantity.removeListener(onValueUpdated);
    super.dispose();
  }
}
