import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foodloop/core/utils/app_colors.dart';

class PaymobWebviewView extends StatefulWidget {
  final String paymentUrl;

  const PaymobWebviewView({super.key, required this.paymentUrl});

  @override
  State<PaymobWebviewView> createState() => _PaymobWebviewViewState();
}

class _PaymobWebviewViewState extends State<PaymobWebviewView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://web-nine-ivory-36.vercel.app/')) {
              // The payment is finished, parse the URL query parameters
              final uri = Uri.parse(request.url);
              final successStr = uri.queryParameters['success'];
              // Paymob typically uses 'success=true'
              final isSuccess = successStr == 'true';

              // Close the webview and return the success status
              Navigator.pop(context, isSuccess);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
      
    try {
      final uri = Uri.parse(widget.paymentUrl);
      if (!uri.hasScheme) {
        throw FormatException('Missing scheme in uri');
      }
      _controller.loadRequest(uri);
    } catch (e) {
      // Don't crash, instead we can show an error or close the screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid payment URL: ${widget.paymentUrl}'),
              backgroundColor: AppColors.error,
            ),
          );
          Navigator.pop(context, false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
