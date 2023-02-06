import 'package:flutter/material.dart';

class LoadableButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  const LoadableButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const loader = SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? loader : Text(text),
    );
  }
}
