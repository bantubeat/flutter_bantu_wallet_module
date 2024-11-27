import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFEBEBEB),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      trailing: Container(
        width: 34,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFEBEBEB),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.chevron_right,
          color: Color(0xFF151515),
          size: 20,
        ),
      ),
      onTap: onTap,
    );
  }
}
