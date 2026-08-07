import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/bantu_wallet_localization.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:intl/intl.dart';

import '../../../../core/generated/locale_keys.g.dart';

class PaymentSuccessPage extends StatefulWidget {
  /// Montant total payé (ex: 2900)
  final double montant;

  /// Devise du montant (ex: 'FCFA')
  final String currency;

  /// Nombre de jetons BZC crédités
  final double jetons;

  /// Identifiant de transaction (ex: 'FTA-2026/789123456')
  final String transactionId;

  /// Moyen de paiement affiché (ex: '**** 4242')
  final String paymentMethod;

  /// Date de la transaction
  final DateTime date;

  /// Nom du service (ex: 'Beatzcoin')
  final String service;

  /// Frais appliqués
  final double frais;

  /// Devise des frais (par défaut identique à `currency`)
  final String? fraisCurrency;

  /// Taux de TVA en % (ex: 19.25)
  final double tvaRate;

  /// Montant de la TVA
  final double tvaAmount;

  /// Email ou contact d'assistance affiché en bas de page
  final String supportEmail;

  /// Callback quand l'utilisateur appuie sur "Download Receipt".
  /// Le bouton affiche un loader tant que le Future n'est pas terminé.
  final Future<void> Function()? onDownloadReceipt;

  /// Callback quand l'utilisateur appuie sur "Fermer".
  /// Si null, fait un Navigator.pop() par défaut.
  final VoidCallback? onClose;

  const PaymentSuccessPage({
    required this.montant,
    required this.currency,
    required this.jetons,
    required this.transactionId,
    required this.paymentMethod,
    required this.date,
    required this.service,
    required this.frais,
    required this.tvaRate,
    required this.tvaAmount,
    super.key,
    this.fraisCurrency,
    this.supportEmail = 'Help@feat-link.com',
    this.onDownloadReceipt,
    this.onClose,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool _isGeneratingPdf = false;

  Future<void> _handleDownloadReceipt() async {
    final callback = widget.onDownloadReceipt;
    if (callback == null || _isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);
    try {
      await callback();
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  String _formatAmount(double value, String currency) {
    final formatted = NumberFormat.decimalPattern('fr').format(value);
    return '$formatted $currency';
  }

  String _formatDate(DateTime date) {
    return DateFormat(
      'MMM d, yyyy',
      BantuWalletLocalization.currentLanguageCode,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icône succès
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F8EA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.credit_score_rounded,
                      color: Color(0xFF2ECC71),
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Titre
                Center(
                  child: Text(
                    LocaleKeys.wallet_module_payment_success_page_title.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Sous-titre
                Center(
                  child: Text(
                    LocaleKeys.wallet_module_payment_success_page_message.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Carte détails transaction
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: LocaleKeys.wallet_module_common_amount.tr(),
                        valueWidget: Text(
                          _formatAmount(widget.montant, widget.currency),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        boldLabel: true,
                      ),
                      const SizedBox(height: 10),
                      _DetailRow(
                        label: LocaleKeys.wallet_module_common_tokens.tr(),
                        valueWidget: Text(
                          '${NumberFormat.decimalPattern('fr').format(widget.jetons)} BZC',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        boldLabel: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          height: 1,
                          color: Color(0xFFD8D8DC),
                        ),
                      ),
                      _DetailRow(
                        label: LocaleKeys
                            .wallet_module_transaction_history_page_table_transaction_id
                            .tr(),
                        valueWidget: _CopyableChip(
                          text: widget.transactionId,
                          onCopied: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.transactionId),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  LocaleKeys.wallet_module_common_copied.tr(),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label:
                            LocaleKeys.wallet_module_common_payment_method.tr(),
                        valueWidget: Text(
                          widget.paymentMethod,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: LocaleKeys
                            .wallet_module_transaction_history_page_table_date
                            .tr(),
                        valueWidget: Text(
                          _formatDate(widget.date),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: LocaleKeys.wallet_module_common_service.tr(),
                        valueWidget: Text(
                          widget.service,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: LocaleKeys.wallet_module_common_fees.tr(),
                        valueWidget: Text(
                          _formatAmount(
                            widget.frais,
                            widget.fraisCurrency ?? widget.currency,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: LocaleKeys
                            .wallet_module_payment_success_page_vat_rate
                            .tr(
                          namedArgs: {
                            'rate': widget.tvaRate
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                          },
                        ),
                        valueWidget: Text(
                          _formatAmount(widget.tvaAmount, widget.currency),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Bouton télécharger le reçu
                Center(
                  child: TextButton.icon(
                    onPressed: _isGeneratingPdf ? null : _handleDownloadReceipt,
                    icon: _isGeneratingPdf
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          )
                        : const Icon(
                            Icons.file_download_outlined,
                            size: 18,
                            color: Colors.black87,
                          ),
                    label: Text(
                      _isGeneratingPdf
                          ? LocaleKeys.wallet_module_payment_success_page_generating_receipt
                              .tr()
                          : LocaleKeys
                              .wallet_module_payment_success_page_download_receipt
                              .tr(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Bouton fermer
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: widget.onClose ??
                        () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: Colors.black,
                    ),
                    label: Text(
                      LocaleKeys.wallet_module_common_close.tr(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Support
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: LocaleKeys
                          .wallet_module_payment_success_page_support_help
                          .tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: widget.supportEmail,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final Widget valueWidget;
  final bool boldLabel;

  const _DetailRow({
    required this.label,
    required this.valueWidget,
    this.boldLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: boldLabel ? 15 : 13,
            fontWeight: boldLabel ? FontWeight.w800 : FontWeight.w500,
            color: boldLabel ? Colors.black : Colors.black54,
          ),
        ),
        valueWidget,
      ],
    );
  }
}

class _CopyableChip extends StatelessWidget {
  final String text;
  final VoidCallback onCopied;

  const _CopyableChip({required this.text, required this.onCopied});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCopied,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.copy, size: 14, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
