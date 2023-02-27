import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

OverlayEntry showSyntaxManual(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  final titleStyle = Theme.of(context).textTheme.titleMedium!;
  final backColor = Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5);

  overlayEntry = OverlayEntry(
    builder: (BuildContext context) => Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.getString("syntax_manual")),
        actions: [
          IconButton(
            onPressed: () => overlayEntry.remove(),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildManualItems(context, titleStyle),
          ),
        ),
      ),
    ),
  );
  overlayState.insert(overlayEntry);
  FocusScope.of(context).unfocus();
  return overlayEntry;
}

List<Widget> buildManualItems(BuildContext context, TextStyle titleStyle) {
  return manualItemKeys.map((key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.getString("syntax_${key}_name"), style: titleStyle),
          Text(context.getString("syntax_${key}_example")),
        ],
      ),
    );
  }).toList();
}

const List<String> manualItemKeys = [
  "headline",
  "sub_headline",
  "quote",
  "code",
  "math"
];
