import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool fullWidth;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final Color? textColor;

  const ActionButton({
    required this.text,
    required this.onPressed,
    this.fullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: prefixIcon,
              ),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
