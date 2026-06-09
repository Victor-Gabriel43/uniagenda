import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool expanded;

  const RoundedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
