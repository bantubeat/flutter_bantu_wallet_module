import 'package:flutter/material.dart';

const kBg = Color(0xFFF2F3F5);
const kCardGrey = Color(0xFFE9EAEC);
const kTextDark = Color(0xFF1A1A1A);
const kTextGrey = Colors.black54;
const kPink = Color(0xFFF7E1E8);
const kPinkText = Color(0xFFB03A5B);

/// AppBar commune : bouton retour, titre + sous-titre, avatar.
class ToolAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  const ToolAppBar({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(24),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
          child:
              const Icon(Icons.person_outline, size: 18, color: Colors.black54),
        ),
      ],
    );
  }
}

/// Petit badge pilule (ex: "DIAMANTS", "ACTIF", "STANDARD").
class Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  final double fontSize;
  const Pill({
    required this.label,
    super.key,
    this.bg = kCardGrey,
    this.textColor = Colors.black54,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: textColor,
        ),
      ),
    );
  }
}

/// Icône circulaire grise, utilisée en en-tête des cartes.
class CircleIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color bg;
  const CircleIcon({
    required this.icon,
    super.key,
    this.size = 44,
    this.bg = kCardGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: size * 0.45, color: Colors.black87),
    );
  }
}

/// Studio photo placeholder (utilisé dans SaloonPrived) — dégradé sombre
/// simulant la photo de studio avec parapluies/softbox.
class StudioImagePlaceholder extends StatelessWidget {
  final double height;
  final String assetPath;
  final BorderRadius? borderRadius;
  final Widget? overlayChild;
  const StudioImagePlaceholder({
    required this.assetPath,
    super.key,
    this.height = 220,
    this.borderRadius,
    this.overlayChild,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: overlayChild == null
            ? Image.asset(assetPath, fit: BoxFit.cover)
            : Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
                child: overlayChild,
              ),
      ),
    );
  }
}
