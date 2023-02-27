import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

import '../../../_styles/textfield.dart';
import 'dynamic_textbox.dart';

class PreviewableTextField extends StatefulWidget {
  final TextEditingController textInput;
  const PreviewableTextField(this.textInput, {super.key});

  @override
  State<PreviewableTextField> createState() => _PreviewableTextFieldState();
}

class _PreviewableTextFieldState extends State<PreviewableTextField> {
  bool canPreview = false;
  bool isPreviewing = false;

  @override
  void initState() {
    super.initState();
    widget.textInput.addListener(checkCanPreview);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Visibility(
            visible: isPreviewing == false,
            child: TextField(
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              controller: widget.textInput,
              keyboardType: TextInputType.multiline,
              autocorrect: false,
              decoration: InputDecoration(
                border: kRoundedBorder,
                focusedBorder: kRoundedBorder,
                filled: true,
                fillColor: Theme.of(context).splashColor,
                contentPadding: kContentPadding,
                hintText: context.getString("content_hint"),
              ),
            ),
          ),
          Visibility(
            visible: isPreviewing == true,
            child: Padding(
              padding: kContentPadding,
              child: SingleChildScrollView(
                child: DynamicTextBox(widget.textInput.text),
              ),
            ),
          ),
          Visibility(
            visible: canPreview,
            child: Positioned(
              right: 0,
              child: TextButton(
                onPressed: () => setState(() => isPreviewing = !isPreviewing),
                child: Text(context.getString(
                    isPreviewing ? "edit_action" : "preview_action")),
              ),
            ),
          )
        ],
      ),
    );
  }

  void checkCanPreview() {
    if (widget.textInput.text.isNotEmpty) {
      if (!canPreview) setState(() => canPreview = true);
    } else {
      if (canPreview) setState(() => canPreview = false);
    }
  }

  @override
  void dispose() {
    widget.textInput.removeListener(checkCanPreview);
    super.dispose();
  }
}
