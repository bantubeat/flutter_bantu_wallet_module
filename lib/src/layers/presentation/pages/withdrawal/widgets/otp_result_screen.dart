import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';

class TransactionResultScreen extends StatelessWidget {
  final bool success;
  final String headerTitle;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;

  /// Bandeau d'info affiché seulement en cas de succès (délai de traitement).
  final String? infoText;
  final String? infoHighlight;
  final String? infoTextSuffix;

  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  const TransactionResultScreen({
    required this.success,
    required this.headerTitle,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.infoText,
    this.infoHighlight,
    this.infoTextSuffix,
    this.secondaryLabel,
    this.onSecondaryPressed,
    super.key,
  });

  static const _ink = Color(0xFF23292C);
  static const _errorRed = Color(0xFFC0392B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child:
                            success ? _buildSuccessIcon() : _buildFailureIcon(),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.45,
                        ),
                      ),
                      if (success && infoText != null) ...[
                        const SizedBox(height: 24),
                        _buildInfoBox(),
                      ],
                    ],
                  ),
                ),
              ),
              ActionButton(
                text: primaryLabel,
                onPressed: onPrimaryPressed,
                borderRadius: BorderRadius.circular(25),
                fullWidth: true,
              ),
              if (success && secondaryLabel != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: onSecondaryPressed,
                    icon: Icon(
                      Icons.file_download_outlined,
                      size: 16,
                      color: Colors.grey[700],
                    ),
                    label: Text(
                      secondaryLabel!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            headerTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.grey[700],
                ),
                children: [
                  TextSpan(text: infoText),
                  if (infoHighlight != null)
                    TextSpan(
                      text: infoHighlight,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  if (infoTextSuffix != null) TextSpan(text: infoTextSuffix),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: _ink,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }

  /// Deux halos flous superposés avec un cercle rouge en X centré au-dessus.
  Widget _buildFailureIcon() {
    return SizedBox(
      width: 150,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 10,
            child: _blob(70, const Color(0x33E0A0A0)),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: _blob(60, Colors.grey.withValues(alpha: 0.2)),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: _errorRed, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 40, spreadRadius: 30),
        ],
      ),
    );
  }
}
