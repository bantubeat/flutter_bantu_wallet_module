import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../navigation/wallet_routes.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({required this.paymentUrl, super.key});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
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
            return NavigationDecision.navigate;
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
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payment'),
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
