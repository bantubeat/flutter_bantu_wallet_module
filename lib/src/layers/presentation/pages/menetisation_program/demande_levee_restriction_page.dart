import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

import 'widgets/app_colors.dart';
import 'widgets/app_widgets.dart';

class DemandeLeveeRestrictionPage extends StatefulWidget {
  const DemandeLeveeRestrictionPage({super.key});

  @override
  State<DemandeLeveeRestrictionPage> createState() =>
      _DemandeLeveeRestrictionPageState();
}

class _DemandeLeveeRestrictionPageState
    extends State<DemandeLeveeRestrictionPage> {
  final _situationController = TextEditingController();
  String? _motif;
  String? _fileName;

  final List<String> _motifs = const [
    LocaleKeys.wallet_module_monetization_program_motif_wrongly_suspended,
    LocaleKeys.wallet_module_monetization_program_motif_kyc_error,
    LocaleKeys.wallet_module_monetization_program_motif_misidentified_content,
    LocaleKeys.wallet_module_monetization_program_motif_other,
  ];

  @override
  void dispose() {
    _situationController.dispose();
    super.dispose();
  }

  Future<void> _pickMotif() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _motifs
              .map(
                (m) => ListTile(
                  title: Text(m.tr()),
                  onTap: () => Navigator.pop(context, m),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected != null) setState(() => _motif = selected);
  }

  void _pickFile() {
    // Hook up file_picker / image_picker here.
    setState(() => _fileName = 'preuve_capture.png');
  }

  void _submit() {
    if (_motif == null || _situationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.wallet_module_monetization_program_form_required.tr(),
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          LocaleKeys.wallet_module_monetization_program_request_sent.tr(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: FeatLinkAppBar(
        title:
            LocaleKeys.wallet_module_monetization_program_request_lift.tr(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Intro card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                  left: BorderSide(color: AppColors.dark, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .wallet_module_monetization_program_lift_heading.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys
                        .wallet_module_monetization_program_lift_heading_description
                        .tr(),
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SectionLabel(
              LocaleKeys.wallet_module_monetization_program_motif_label.tr(),
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickMotif,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardGrey,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _motif?.tr() ??
                          LocaleKeys
                              .wallet_module_monetization_program_select_motif
                              .tr(),
                      style: TextStyle(
                        fontSize: 14.5,
                        color: _motif == null
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            SectionLabel(
              LocaleKeys.wallet_module_monetization_program_situation_label
                  .tr(),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _situationController,
                maxLines: 5,
                style: const TextStyle(
                  fontSize: 14.5,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: LocaleKeys
                      .wallet_module_monetization_program_situation_hint.tr(),
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            SectionLabel(
              LocaleKeys.wallet_module_monetization_program_evidence_label
                  .tr(),
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickFile,
              child: DottedBorderBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_upload,
                        size: 30,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _fileName ??
                            LocaleKeys
                                .wallet_module_monetization_program_click_to_upload
                                .tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LocaleKeys
                            .wallet_module_monetization_program_upload_formats
                            .tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: AppColors.cardGreyDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_requests_handled_24h
                              .tr(),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_false_declaration_warning
                              .tr(),
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            DarkPillButton(
              label: LocaleKeys
                  .wallet_module_monetization_program_send_request.tr(),
              trailingIcon: Icons.send,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),

            Center(
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                LocaleKeys
                    .wallet_module_monetization_program_secure_infrastructure
                    .tr(),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple dashed-border container for the upload dropzone.
class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(14),
    );
    final paint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
