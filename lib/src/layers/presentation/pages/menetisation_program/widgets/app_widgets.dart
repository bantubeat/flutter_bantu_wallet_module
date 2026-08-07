import 'package:flutter/material.dart';
import 'app_colors.dart';

class FeatLinkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const FeatLinkAppBar({required this.title, super.key, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.cardGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.security,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Small uppercase, letter-spaced section label ("MOTIF DE CONTESTATION", etc.)
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.textMuted,
      ),
    );
  }
}

/// Full-width dark pill button, used for primary CTAs.
class DarkPillButton extends StatelessWidget {
  final String label;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final Color? color;

  const DarkPillButton({
    required this.label,
    super.key,
    this.trailingIcon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.dark,
          disabledBackgroundColor: AppColors.textMuted.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pink "DISPONIBLE" style status badge.
class StatusBadge extends StatelessWidget {
  final String text;
  final Color background;
  final Color textColor;

  const StatusBadge({
    required this.text,
    super.key,
    this.background = AppColors.pinkBg,
    this.textColor = AppColors.pinkText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
