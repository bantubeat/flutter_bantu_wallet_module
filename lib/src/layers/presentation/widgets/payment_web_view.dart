import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../navigation/wallet_routes.dart';

/// Returns null if [url] is not a deposit payment completion URL
/// (`{API}/api/deposit-payment/completed/{uuid}`), otherwise a record
/// holding the payment uuid (null when "unknown" or empty).
({String? uuid})? parsePaymentCompletedUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.path.contains('/deposit-payment/completed/')) {
    return null;
  }

  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  final last = segments.isEmpty ? null : segments.last;
  final isMissing = last == null || last == 'completed' || last == 'unknown';
  return (uuid: isMissing ? null : last);
}

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({required this.paymentUrl, super.key});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  FutureOr<NavigationDecision> _overrideUrlLoadingDecision(
    String urlString,
  ) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null) {
      final browserSchemeList = [
        'http',
        'https',
        'file',
        'chrome',
        'data',
        'javascript',
        'about',
      ];

      if (browserSchemeList.contains(uri.scheme)) {
        return NavigationDecision.navigate;
      }

      // Handle non browser scheme
      if (await canLaunchUrl(uri)) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
        return NavigationDecision.prevent;
      }
    }

    launchUrlString(urlString, mode: LaunchMode.externalApplication);
    return NavigationDecision.prevent;
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (err) {
            if (err.errorType == WebResourceErrorType.unsupportedScheme) {
              final url = err.url;
              if (url != null) _overrideUrlLoadingDecision(url);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Check if the URL is the deposit payment completion page
            final completed = parsePaymentCompletedUrl(request.url);
            if (completed != null) {
              // Navigate back to app and show transaction screen
              Navigator.of(context).pop();
              Modular.get<WalletRoutes>().transactions.push(completed.uuid);

              return NavigationDecision.prevent;
            }

            // Check if the URL is the completion URL
            if (request.url.contains('bantubeat.com/auth/login')) {
              // && request.url.contains('after-payment')) {
              // Extract payment UUID if needed
              final paymentUuid = request.url.contains('after-payment')
                  ? Uri.parse(request.url).path.split('/').last
                  : null;

              // Navigate back to app and show transaction screen
              Navigator.of(context).pop();
              Modular.get<WalletRoutes>().transactions.push(paymentUuid);

              return NavigationDecision.prevent;
            }

            return _overrideUrlLoadingDecision(request.url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Payment'),
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
