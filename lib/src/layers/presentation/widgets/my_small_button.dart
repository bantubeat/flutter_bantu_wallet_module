import 'package:flutter/material.dart';

class MySmallButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;
  final bool useFittedBox;

  const MySmallButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.useFittedBox = false,
    super.key,
  });

  Widget _buildContainer() {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: 12.0,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Visibility(
        visible: useFittedBox,
        replacement: textWidget,
        child: FittedBox(child: textWidget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return _buildContainer();
    return InkWell(
      onTap: onTap,
      child: _buildContainer(),
    );
  }
}
