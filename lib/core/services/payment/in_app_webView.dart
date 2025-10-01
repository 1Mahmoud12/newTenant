/*import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum PayTapsStatus { A, C, D }

class MyInAppWebView extends StatefulWidget {
  final String authorizationUrl;
  final BuildContext scaffoldContext;
  final void Function(String)? onPageFinished;
  final void Function(String)? onPageStarted;
  final void Function(bool, Object?)? onPopInvokedWithResult;

  const MyInAppWebView(
      {Key? key, required this.authorizationUrl, required this.scaffoldContext, this.onPageFinished, this.onPopInvokedWithResult, this.onPageStarted})
      : super(key: key);

  @override
  State<MyInAppWebView> createState() => _MyInAppWebViewState();
}

class _MyInAppWebViewState extends State<MyInAppWebView> {
  late WebViewController controller;
  bool _paymentProcessed = false; // To prevent multiple navigations

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar if needed.
          },
          onPageStarted: widget.onPageStarted,
          onPageFinished: (String url) async {
            widget.onPageFinished?.call(url);
            log('Page finished loading: $url');
            _checkPaymentStatus(url);
          },
          onHttpError: (HttpResponseError error) {
            log('HTTP Error: ${error.toString()}');
          },
          onWebResourceError: (WebResourceError error) {
            log('Web Resource Error: ${error.errorCode} - ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) async {
            final response = await http.get(
              Uri.parse('https://sa1.payments.tap.company/...'),
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15A372 Safari/604.1'
              },
            );
            log('esponse.request?.url ${response.request?.url}'); // Final redirected URL
            log('Navigating to: ${request.url}');
            log('current to: ${await controller.currentUrl()}');
            widget.onPageStarted?.call(request.url);
            _checkPaymentStatus(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));

    // Timeout fallback after 15 seconds if no redirect occurs
    Future.delayed(Duration(seconds: 15), () async {
      final currentUrl = await controller.currentUrl();
      if (!_paymentProcessed && currentUrl?.contains('response.aspx') == true) {
        _paymentProcessed = true;
        finish(context);
        toast(language.yourPaymentFailedPleaseTryAgain);
      }
    });

    // Controller setup...
  }

  void _checkPaymentStatus(String url) {
    if (_paymentProcessed) {
      return;
    }

    if (url.contains('https://app.m-clean.net/payment-success')) {
      setState(() {
        _paymentProcessed = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        finish(context);
        toast(language.paymentSuccess);
      });
      log('Payment success detected!');
      widget.onPageStarted?.call(url);
    } else if (url.contains('https://app.m-clean.net/payment-failed')) {
      setState(() {
        _paymentProcessed = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        finish(context);
        toast(language.yourPaymentFailedPleaseTryAgain);
      });
      log('Payment failed detected!');
      widget.onPageStarted?.call(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_paymentProcessed, // Prevent popping after payment status is determined
      onPopInvoked: (didPop) async {
        if (didPop) {
          widget.onPopInvokedWithResult?.call(false, null); // Indicate a manual pop
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: blackColor),
          centerTitle: true,
          title: Text(
            language.electronicPayment,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: WebViewWidget(
          controller: controller,
          gestureRecognizers: {},
        ),
      ),
    );
  }
}*/
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum PayTapsStatus { A, C, D }

class MyInAppWebView extends StatefulWidget {
  final String authorizationUrl;
  final BuildContext scaffoldContext;
  final void Function(String)? onPageFinished;
  final void Function(String)? onPageStarted;
  final void Function(bool, Object?)? onPopInvokedWithResult;

  const MyInAppWebView(
      {Key? key, required this.authorizationUrl, required this.scaffoldContext, this.onPageFinished, this.onPopInvokedWithResult, this.onPageStarted})
      : super(key: key);

  @override
  State<MyInAppWebView> createState() => _MyInAppWebViewState();
}

class _MyInAppWebViewState extends State<MyInAppWebView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: true,
      clearCache: true,
      disableHorizontalScroll: false,
      disableVerticalScroll: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      allowsBackForwardNavigationGestures: true,
      limitsNavigationsToAppBoundDomains: true,
      //i: true, // optional for debugging
      // Add this to prevent WebKit crashes
      // disallowOverScroll: true,
      // enableViewportScale: true,
      // sharedCookiesEnabled: true,
    ),
  );

  @override
  void dispose() {
    webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent automatic back navigation
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Handle back button press
          if (widget.onPopInvokedWithResult != null) {
            widget.onPopInvokedWithResult!.call(false, null);
          }
          // Safely close the screen
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            'Moyassar Credit'.tr(),
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (widget.onPopInvokedWithResult != null) {
                widget.onPopInvokedWithResult!.call(false, null);
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.authorizationUrl)),
          initialOptions: options,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            if (url != null) {
              log('Page started loading: $url');
              widget.onPageStarted?.call(url.toString());

              // Check for Tap's response URL
              if (url.toString().contains('payments.tap.company/gosell/v6/payment/response.aspx')) {
                log('Detected Tap response page - waiting for final redirect');
              }
              // Check for success URL
              else if (url.toString().contains('app.m-clean.net/payment-success')) {
                log('Payment success detected!');
                // Let the parent handle success logic
              }
              // Check for failure URL
              else if (url.toString().contains('app.m-clean.net/payment-fail')) {
                log('Payment failure detected!');
                // Let the parent handle failure logic
              }
            }
          },
          onLoadStop: (controller, url) async {
            if (url != null && mounted) {
              // Check if mounted before proceeding
              log('Page finished loading: $url');
              widget.onPageFinished?.call(url.toString());

              if (url.toString().contains('app.m-clean.net/payment-success')) {
                // Prevent further navigation
                controller.stopLoading();

                // Wait a moment before closing
                await Future.delayed(const Duration(milliseconds: 300));

                // Check mounted again before navigating
                if (mounted) {
                  if (widget.onPopInvokedWithResult != null) {
                    widget.onPopInvokedWithResult!(true, "success");
                  }
                  Navigator.of(widget.scaffoldContext).pop("success");
                }
              }
              // Similar changes for failure URL...
            }
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;
            log('Navigating to: $uri');

            if (uri.toString().contains('app.m-clean.net/payment-success')) {
              log('Payment success override detected!');
              // Allow navigation so the parent's onPageStarted can handle it
              return NavigationActionPolicy.ALLOW;
            }

            // Allow all other navigations
            return NavigationActionPolicy.ALLOW;
          },
          onConsoleMessage: (controller, consoleMessage) {
            log('Console: ${consoleMessage.message}');
          },
          onProgressChanged: (controller, progress) {
            // You can add a progress indicator here if needed
          },
          iosOnNavigationResponse: (controller, navigationResponse) async {
            log('iosOnNavigationResponse ${navigationResponse.response?.url}');
            return null;
          },
          // onReceivedHttpError: (controller, request, errorResponse) {
          //   log('HTTP Error: ${errorResponse.statusCode}');
          // },
          // onReceivedError: (controller, request, error) {
          //   log('WebView Error: $error');
          // },
        ),
      ),
    );
  }
}
